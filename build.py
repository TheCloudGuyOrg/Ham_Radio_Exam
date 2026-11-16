#!/usr/bin/env python3
"""Build one self-contained index.html from template.html, style.css, the
three question pools and their figure images.  Run: python3 build.py"""
import base64, json, os

D = os.path.dirname(os.path.abspath(__file__))
EXAMS = [  # order: Technician, General, Extra
    dict(name="Technician", dir="HAM_Radio_Technician_July_2026_Practice_Exam", pool="2026-2030", effective="July 1, 2026", examSize=35, passScore=26),
    dict(name="General", dir="HAM_Radio_General_June_2023_Practice_Exam", pool="2023-2027", effective="July 1, 2023", examSize=35, passScore=26),
    dict(name="Extra", dir="HAM_Radio_Extra_Nov_2024_Practice_Exam", pool="2024-2028", effective="July 1, 2024", examSize=50, passScore=37),
]


def dump(o):
    return json.dumps(o, separators=(",", ":")).replace("</", "<\\/")


figures, exams = {}, []
for e in EXAMS:
    p = os.path.join(D, e["dir"])
    with open(os.path.join(p, "questions.json")) as fh:
        qs = json.load(fh)
    for q in qs:
        f = q.get("figure")
        if f and f not in figures:
            fn = f if f.endswith(".png") else f + ".png"
            with open(os.path.join(p, fn), "rb") as img:
                figures[f] = "data:image/png;base64," + base64.b64encode(img.read()).decode()
    meta = {k: e[k] for k in ("name", "pool", "effective", "examSize", "passScore")}
    meta["questions"] = qs
    exams.append(meta)

with open(os.path.join(D, "template.html")) as fh:
    html = fh.read()
with open(os.path.join(D, "style.css")) as fh:
    css = fh.read()
html = html.replace("/*CSS*/", css).replace("/*FIGURES*/", dump(figures)).replace("/*EXAMS*/", dump(exams))
with open(os.path.join(D, "index.html"), "w") as fh:
    fh.write(html)
print("wrote index.html:", {e["name"]: len(e["questions"]) for e in exams}, len(figures), "figures")
