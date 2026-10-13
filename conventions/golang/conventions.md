# GOLANG ENGINEERING & IDIOMATIC DESIGN CONVENTIONS

## 1. PROJECT STRUCTURE & STANDARD LAYOUT
- Follow Standard Go Project Layout:
  - `/cmd/<app-name>/main.go`: Application entrypoint (minimal wiring and dependency injection).
  - `/internal/`: Private application code (domain, use cases, repository implementations). Code inside `internal/` cannot be imported by external modules.
  - `/pkg/`: Public library code intended to be shared across projects.
- **Package Cohesion**: Name packages by what they provide, not by what they contain (e.g., `user`, `auth`, `postgres`, not `utils`, `helpers`, `models`).

## 2. IDIOMATIC ERROR HANDLING
- **Errors are Values**: Never ignore returned errors (`_ = doSomething()`). Always check `if err != nil`.
- **Error Wrapping**: Wrap errors with context using `fmt.Errorf("action description: %w", err)`.
- **Inspecting Errors**: Use `errors.Is(err, ErrNotFound)` for sentinel error checks and `errors.As(err, &targetErr)` for custom typed error inspection.
- **Never Panic**: Do not use `panic()` in production libraries or handlers. Return explicit errors up the call stack.

```go
package service

import (
    "errors"
    "fmt"
)

var ErrUserNotFound = errors.New("user not found")

func (s *UserService) GetUser(id string) (*User, error) {
    user, err := s.repo.FindByID(id)
    if err != nil {
        if errors.Is(err, repo.ErrNotFound) {
            return nil, fmt.Errorf("%w: %s", ErrUserNotFound, id)
        }
        return nil, fmt.Errorf("failed to fetch user %s: %w", id, err)
    }
    return user, nil
}
```

## 3. CONCURRENCY & GOROUTINES
- **Goroutine Ownership**: The function that spawns a goroutine must be responsible for terminating it. Never spawn orphaned goroutines.
- **Context Propagation**: Always pass `ctx context.Context` as the first argument in I/O and network operations. Respect cancellation (`ctx.Done()`) and deadlines.
- **Synchronization**:
  - Prefer communication over sharing memory (channels).
  - When sharing memory, use `sync.Mutex` or `sync.RWMutex` with `defer mu.Unlock()`.
  - Always run tests with the race detector enabled: `go test -race ./...`.

## 4. INTERFACES & DEPENDENCY INVERSION
- **Accept Interfaces, Return Structs**: Define interfaces where they are consumed (client-side), not where they are implemented.
- **Keep Interfaces Small**: Interfaces should typically have 1 to 3 methods (e.g., `io.Reader`, `io.Writer`).

## 5. TOOLING & CODE QUALITY
- **Linter**: Use `golangci-lint` with strict presets enabled (`govet`, `errcheck`, `staticcheck`, `revive`, `gocritic`).
- **Zero Warnings**: Treat all linter warnings as fatal errors in CI/CD.
