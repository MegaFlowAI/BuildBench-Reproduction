import csv, hashlib, json, re
from datetime import datetime
import sys
from pathlib import Path

ledger = Path(sys.argv[1])
catalog = {}
for row in csv.DictReader(ledger.open()):
    case_id = row['case_id']
    filename = Path(row['official_log'])
    timestamp = versions = None
    parallel, mode = 4, '-b'
    distribution = None
    options = []
    with filename.open('rb') as handle:
        while line := handle.readline(262144):
            if line.startswith(b'Distribution:') and distribution is None:
                distribution = line.decode(errors='replace').split(':',1)[1].strip()
            if line.startswith(b'Package versions: '):
                versions = dict(item.split('_', 1) for item in line.decode(errors='replace').split()[2:] if '_' in item)
                versions = {k:v for k,v in versions.items() if not (k.startswith('sbuild-build-depends-') and v == '0.invalid.0')}
            elif line.startswith(b'Build finished at '):
                value = line.decode().strip().split()[-1]
                for fmt in ('%Y-%m-%dT%H:%M:%SZ','%Y%m%d-%H%M'):
                    try:
                        timestamp = datetime.strptime(value, fmt).strftime('%Y%m%dT%H%M%SZ')
                        break
                    except ValueError:
                        pass
            elif line.startswith(b'DEB_BUILD_OPTIONS='):
                opts = line.decode().split('=',1)[1].strip().strip("'").split()
                for opt in opts:
                    if opt.startswith('parallel='):
                        parallel = int(opt.split('=')[1])
                    else:
                        options.append(opt)
            elif line.startswith(b'Command: dpkg-buildpackage '):
                found = re.search(rb' (-[bBA])(?: |\s*$)',line)
                if found:
                    mode = found[1].decode()
            elif line.startswith(b'dpkg-buildpackage: error: debian/rules binary-'):
                if b'binary-arch' in line:
                    mode = '-B'
                elif b'binary-indep' in line:
                    mode = '-A'
            if versions and timestamp:
                break
    # A few buildd logs end before an explicit completion stamp. Use the start stamp when present.
    if timestamp is None:
        with filename.open('rb') as handle:
            for line in handle:
                m = re.search(rb'^(?:Build started at|Start Time:) (\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ)', line)
                if m:
                    timestamp = re.sub(r'[:-]', '', m[1].decode())
                    break
                if handle.tell() > 1000000:
                    break
    catalog[case_id] = {
        'architecture': 'arm64' if row['side']=='arm' else 'amd64',
        'suite':case_id.split('-')[1],
        'snapshot':timestamp,
        'mode':mode,
        'jobs':parallel,
        'options':options,
        'distribution': distribution,
        'handover_status': row['state'],
        'packages': versions or {},
    }
assert len(catalog)==200
print(json.dumps(catalog, sort_keys=True, indent=2))
