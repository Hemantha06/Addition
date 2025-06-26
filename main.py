from fastapi import FastAPI, Query
from pydantic import BaseModel

app = FastAPI()

@app.get("/add")
def add(a: float = Query(...), b: float = Query(...)):
    return {"result": a + b}