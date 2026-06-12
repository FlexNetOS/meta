import sys, os, re, glob
ROOT="/home/drdave/Desktop/meta/RuVector"
def walk(crate_dir):
    d=os.path.join(ROOT,crate_dir)
    ct=os.path.join(d,"Cargo.toml")
    name=desc=""
    if os.path.exists(ct):
        t=open(ct,errors="ignore").read()
        m=re.search(r'(?ms)^\[package\].*?(?=^\[|\Z)',t); sec=m.group(0) if m else t
        nm=re.search(r'(?m)^\s*name\s*=\s*"([^"]+)"',sec); name=nm.group(1) if nm else crate_dir
        dm=re.search(r'(?m)^\s*description\s*=\s*"([^"]+)"',sec); desc=dm.group(1) if dm else ""
        deps=re.findall(r'(?m)^\s*((?:ruv|rvf|rvm|rvagent|sona|cognitum|mcp|hailo)[a-z0-9_-]*)\s*=',t)
    else: deps=[]
    print(f"\n████ {name}   [{crate_dir}]")
    if desc: print(f"  «{desc}»")
    if deps: print(f"  int-deps: {' '.join(sorted(set(deps)))}")
    src=os.path.join(d,"src/lib.rs")
    if not os.path.exists(src): src=os.path.join(d,"src/main.rs")
    if not os.path.exists(src):
        # find any top src file
        cands=glob.glob(os.path.join(d,"src/*.rs"))
        src=cands[0] if cands else None
    if not src or not os.path.exists(src): print("  (no src/lib.rs)"); return
    lines=open(src,errors="ignore").read().splitlines()
    doc=[l[3:].strip() for l in lines[:40] if l.startswith("//!")]
    if doc: print("  doc: "+" / ".join(doc[:6])[:300])
    pub=[]
    for l in lines:
        s=l.strip()
        m=re.match(r'pub(?:\s*\(crate\))?\s+(mod|fn|struct|enum|trait|type|const)\s+([A-Za-z0-9_]+)',s)
        if m: pub.append(f"{m.group(1)} {m.group(2)}")
    # dedup keep order
    seen=set(); uniq=[x for x in pub if not (x in seen or seen.add(x))]
    mods=[x for x in uniq if x.startswith("mod ")]
    api=[x for x in uniq if not x.startswith("mod ")]
    if mods: print("  pub mods: "+", ".join(m[4:] for m in mods)[:240])
    if api: print(f"  pub API ({len(api)}): "+", ".join(api[:24])[:380])
for c in sys.argv[1:]: walk(c)
