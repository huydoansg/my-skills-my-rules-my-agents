# REACT & MODERN FRONTEND CONVENTIONS

## 1. COMPONENT ARCHITECTURE & COMPOSITION
- **Functional Components Only**: Class components are forbidden.
- **Single Responsibility Component (SRP)**:
  - Separate **Container/Smart Components** (data fetching, state orchestration) from **Presentational/Dumb Components** (pure UI rendering, props-only).
  - Component files must not exceed 150-200 lines. Extract sub-components and custom hooks when complexity grows.
- **Explicit Prop Contracts**: Define props using TypeScript `interface` or `type`. Avoid passing huge, monolithic model objects when a component only needs 2 fields.

## 2. STATE MANAGEMENT & DATA FETCHING
- **Server State vs. Client State**:
  - Do not duplicate server state into `useState` or `useEffect`.
  - Use modern data-fetching libraries with built-in caching and revalidation (e.g., TanStack Query / React Query, SWR, or RTK Query).
  - Reserve global client state (Zustand, Redux Toolkit) strictly for ephemeral, client-only UI state (e.g., active modal, user preferences, theme).
- **Minimal Local State**: Derive state whenever possible instead of synchronizing multiple state variables.

```tsx
// BAD: Redundant state sync
const [firstName, setFirstName] = useState('');
const [lastName, setLastName] = useState('');
const [fullName, setFullName] = useState(''); // Redundant!

// GOOD: Derived state
const fullName = `${firstName} ${lastName}`.trim();
```

## 3. HOOKS & SIDE-EFFECT RULES
- **Eliminate Unnecessary `useEffect`**:
  - Never use `useEffect` to transform data for rendering; compute it during render.
  - Do not use `useEffect` to handle user interactions; handle them in direct event handlers (`onClick`, `onSubmit`).
  - Always clean up side effects (event listeners, intervals, WebSocket subscriptions, AbortControllers) in `useEffect` return functions.
- **Custom Hooks**: Extract reusable behavior, subscriptions, or complex event handling into dedicated custom hooks prefixed with `use` (e.g., `useDebounce`, `useWindowDimensions`).

## 4. PERFORMANCE & RENDERING OPTIMIZATION
- **Avoid Premature Optimization**: Do not wrap every callback in `useCallback` or every value in `useMemo` unless profiling shows expensive computations or re-render churn.
- **Stable Keys in Lists**: Always use unique, persistent IDs for list `key` props. Never use array index (`key={index}`) if the list can be reordered, filtered, or mutated.
- **Code Splitting & Lazy Loading**: Use `React.lazy()` and `Suspense` for heavy routes and third-party widgets (e.g., rich text editors, chart libraries).

## 5. ACCESSIBILITY (A11Y) & DESIGN SYSTEM INTEGRITY
- **Semantic HTML First**: Use `<button>`, `<nav>`, `<main>`, `<article>`, `<header>` instead of `<div>` with `onClick`.
- **Keyboard Navigation & ARIA**: Ensure interactive elements are keyboard focusable (`Tab`), interactive via `Enter`/`Space`, and contain appropriate `aria-label` or `aria-describedby` attributes.
