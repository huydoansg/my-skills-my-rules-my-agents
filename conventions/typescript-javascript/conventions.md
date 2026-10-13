# TYPESCRIPT & JAVASCRIPT CONVENTIONS

## 1. COMPILER & TYPE SYSTEM
- **Strict Mode Enabled**: Always configure `tsconfig.json` with `"strict": true`, `"noImplicitAny": true`, `"strictNullChecks": true`, `"noUncheckedIndexedAccess": true`.
- **Zero `any` Policy**:
  - Never use `any`. Use `unknown` for unvalidated payloads and narrow types via type guards or validation libraries.
  - Avoid type assertions (`as Type`) unless interfacing with poorly typed third-party JavaScript libraries. Prefer `satisfies` operator.
- **Branded & Nominal Types**: Use branded types for domain identifiers (e.g., `UserId`, `OrderId`) to prevent accidentally swapping primitive strings/numbers.

```typescript
export type Brand<T, B> = T & { readonly __brand: B };
export type UserId = Brand<string, 'UserId'>;
export type OrderId = Brand<string, 'OrderId'>;
```

## 2. RUNTIME VALIDATION & BOUNDARIES
- **Schema Validation with Zod / Valibot**:
  - Validate all data arriving from HTTP requests, environment variables, message queues, and local storage at runtime.
  - Infer TypeScript types directly from validation schemas (`z.infer<typeof Schema>`).

```typescript
import { z } from 'zod';

export const CreateUserSchema = z.object({
  email: z.string().email(),
  age: z.number().int().min(18),
});
export type CreateUserInput = z.infer<typeof CreateUserSchema>;
```

## 3. ASYNC PROGRAMMING & ERROR HANDLING
- **Never Ignore Promises**: Always `await` promises or handle their rejection. Enable `@typescript-eslint/no-floating-promises`.
- **Structured Error Handling**:
  - Use custom domain error classes or `Result<T, E>` pattern (e.g., `neverthrow`) instead of untyped `throw new Error()`.
  - Handle concurrency safely: Use `Promise.allSettled()` when independent operations may fail without aborting all sibling requests.

```typescript
export type Result<T, E = Error> = 
  | { readonly ok: true; readonly value: T }
  | { readonly ok: false; readonly error: E };
```

## 4. CODE HYGIENE & IMMUTABILITY
- **Immutability by Default**:
  - Prefer `const` over `let`. Never use `var`.
  - Use `Readonly<T>`, `readonly` array modifiers (`readonly string[]`), and `as const` for object literals.
  - Avoid mutating objects in place; use spread operators or structured clone for immutable transformations.
- **Pure Functions**: Write deterministic pure functions for business calculations to facilitate effortless unit testing.
