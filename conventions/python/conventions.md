# PYTHON ENGINEERING & ARCHITECTURE CONVENTIONS

## 1. TYPE ANNOTATIONS & STATIC ANALYSIS
- **Mandatory Type Hints (PEP 484 / 585 / 604)**:
  - Every function parameter and return type must be annotated.
  - Use modern syntax: `list[str]` instead of `typing.List[str]`, `str | None` instead of `typing.Optional[str]`.
  - Enforce static analysis with `pyright` or `mypy --strict`. Untyped `Any` is prohibited in core domain logic.

## 2. DATA MODELING & VALIDATION (PYDANTIC V2)
- **Immutable Domain Models**: Use `pydantic.BaseModel` with `model_config = ConfigDict(frozen=True, extra="forbid")` or standard `@dataclass(frozen=True)`.
- **Runtime Validation**: Use Pydantic field validators (`@field_validator`) for business invariants at API and input boundaries.

```python
from pydantic import BaseModel, ConfigDict, EmailStr, Field

class CreateUserCommand(BaseModel):
    model_config = ConfigDict(frozen=True, extra="forbid")

    email: EmailStr
    username: str = Field(min_length=3, max_length=50)
    age: int = Field(ge=18, le=120)
```

## 3. ASYNCHRONOUS PROGRAMMING (ASYNCIO)
- **Do Not Block the Event Loop**:
  - Never call blocking I/O (e.g., standard `requests.get()`, `time.sleep()`, synchronous DB drivers) inside `async def` functions.
  - Use non-blocking equivalents (`httpx.AsyncClient`, `asyncio.sleep`, `asyncpg`, `motor`).
  - If blocking calls are unavoidable, run them in an executor: `await asyncio.to_thread(blocking_func, arg)`.
- **Task Management**: Always shield or properly await `asyncio.create_task()`. Capture task exceptions; never allow fire-and-forget tasks to silently crash.

## 4. CODE QUALITY & TOOLING
- **Linter & Formatter**: Use **Ruff** for high-speed linting and formatting. Treat all warnings as errors in CI.
- **Exceptions & Errors**:
  - Inherit from custom base exceptions (e.g., `DomainException`). Never catch bare `except:` or `except Exception:` without logging or re-raising.
- **Dependency Management**: Use modern dependency managers with deterministic lockfiles (**uv** or **Poetry**). Never commit unpinned `requirements.txt`.
