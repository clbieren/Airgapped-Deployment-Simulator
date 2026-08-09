from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

# Görevleri RAM'de tutan basit bir liste
todos = []
next_id = 1

# Bir görevin nasıl görüneceğini tanımlıyoruz (veri şeması)
class Todo(BaseModel):
    title: str
    done: bool = False

@app.get("/")
def root():
    return {"message": "Todo API calisiyor", "version": "1.0"}

@app.get("/todos")
def list_todos():
    return todos

@app.post("/todos")
def create_todo(todo: Todo):
    global next_id
    new_todo = {"id": next_id, "title": todo.title, "done": todo.done}
    todos.append(new_todo)
    next_id += 1
    return new_todo

@app.put("/todos/{todo_id}")
def update_todo(todo_id: int, todo: Todo):
    for t in todos:
        if t["id"] == todo_id:
            t["title"] = todo.title
            t["done"] = todo.done
            return t
    raise HTTPException(status_code=404, detail="Todo bulunamadi")

@app.delete("/todos/{todo_id}")
def delete_todo(todo_id: int):
    for t in todos:
        if t["id"] == todo_id:
            todos.remove(t)
            return {"message": "Silindi"}
    raise HTTPException(status_code=404, detail="Todo bulunamadi")
