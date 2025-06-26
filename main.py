from fastapi import FastAPI, Form

app = FastAPI()

@app.post("/add")
def add(a: float = Form(...), b: float = Form(...)):
    return {"result": a + b}
