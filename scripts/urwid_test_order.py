"""复用历史日志中的 urwid 测试发现顺序。"""
import os
import sys

MODULES = (
    "test_str_util.py", "test_container.py", "test_listbox.py", "test_util.py",
    "test_escapes.py", "test_widget.py", "test_event_loops.py", "test_graphics.py",
    "test_text_layout.py", "test_decoration.py", "test_canvas.py",
)
ORDER = {name: index for index, name in enumerate(MODULES)}
listdir = os.listdir


def list_tests_in_historical_order(path="."):
    entries = listdir(path)
    if isinstance(path, str) and os.path.normpath(path).endswith("/urwid/tests"):
        return sorted(entries, key=lambda name: ORDER.get(name, len(ORDER)))
    return entries


if os.path.basename(sys.argv[0]) == "setup.py" and "test" in sys.argv[1:]:
    os.listdir = list_tests_in_historical_order
