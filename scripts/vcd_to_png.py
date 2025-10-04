#!/usr/bin/env python3
# usage: python3 scripts/vcd_to_png.py build/alu.vcd docs/wave.png
import sys, re
import matplotlib.pyplot as plt

if len(sys.argv) < 3:
    print("usage: vcd_to_png.py <input.vcd> <output.png>")
    sys.exit(1)

vcd_path, out_png = sys.argv[1], sys.argv[2]
sym_to_name, name_to_width = {}, {}
base_name_re = re.compile(r"^(.+?)(?:\s*\[.*\])?$")

with open(vcd_path, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

i = 0
while i < len(lines):
    line = lines[i].strip()
    if line.startswith("$var"):
        toks = line.split()
        width = int(toks[2]); sym = toks[3]
        raw_name = " ".join(toks[4:-1])
        m = base_name_re.match(raw_name)
        name = m.group(1) if m else raw_name
        sym_to_name[sym] = name
        name_to_width[name] = width
    if line.startswith("$enddefinitions"):
        i += 1; break
    i += 1

wanted = {"a","b","y","op","z","n","c","v"}
sym_wanted = {s for s,nm in sym_to_name.items() if nm in wanted}

t = 0
waves = {nm: [] for nm in wanted}

def commit(nm, tt, vv): waves[nm].append((tt, vv))

while i < len(lines):
    s = lines[i].strip()
    if not s:
        i += 1; continue
    if s[0] == '#':
        t = int(s[1:])
    elif s[0] in '01xzXZ' and len(s) >= 2:
        val, sym = s[0], s[1:]
        if sym in sym_wanted:
            nm = sym_to_name[sym]
            v = 0 if val in 'xXzZ' else int(val)
            commit(nm, t, v)
    elif s[0] == 'b':
        try: bits, sym = s[1:].split()
        except ValueError: i += 1; continue
        if sym in sym_wanted:
            nm = sym_to_name[sym]
            clean = ''.join('0' if ch in 'xXzZ' else ch for ch in bits) or '0'
            commit(nm, t, int(clean, 2))
    i += 1

def build_series(name):
    data = waves[name]
    if not data: return [0],[0]
    ts, vs = [], []
    last_t, last_v = data[0]
    ts.append(last_t); vs.append(last_v)
    for (tt, vv) in data[1:]:
        ts.append(tt); vs.append(last_v)
        ts.append(tt); vs.append(vv)
        last_v = vv
    return ts, vs

import matplotlib
plt.figure(figsize=(10,6))

ax1 = plt.subplot(2,1,1)
for nm in ["a","b","y"]:
    if waves[nm]:
        ts, vs = build_series(nm)
        ax1.step(ts, vs, where='post', label=nm)
ax1.set_title("ALU Inputs/Outputs (a, b, y)")
ax1.set_ylabel("Value")
ax1.legend(loc="upper right"); ax1.grid(True, linestyle=":")

ax2 = plt.subplot(2,1,2)
if waves["op"]:
    ts, vs = build_series("op")
    ax2.step(ts, vs, where='post', label="op")
for idx, nm in enumerate(["z","n","c","v"]):
    if waves[nm]:
        ts, vs = build_series(nm)
        ax2.step(ts, [vv + 0.15*idx for vv in vs], where='post', label=nm)
ax2.set_title("Opcode and Flags"); ax2.set_xlabel("Time (ps)"); ax2.set_ylabel("Code/Flag")
ax2.legend(loc="upper right"); ax2.grid(True, linestyle=":")

plt.tight_layout(); plt.savefig(out_png, dpi=160)
print(f"Saved {out_png}")
