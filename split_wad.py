# Uso: python split_wad.py doom1.wad
# Parte el WAD en modulos base64 dentro de src/client/WadChunks/
import base64, sys, pathlib
data = pathlib.Path(sys.argv[1]).read_bytes()
b64 = base64.b64encode(data).decode()
STEP = 120000  # multiplo de 4
out = pathlib.Path("src/client/WadChunks"); out.mkdir(parents=True, exist_ok=True)
for f in out.glob("c*.lua"): f.unlink()
for n, i in enumerate(range(0, len(b64), STEP), 1):
    (out / f"c{n:04d}.lua").write_text('return "' + b64[i:i+STEP] + '"')
print(n, "trozos,", len(data), "bytes")
