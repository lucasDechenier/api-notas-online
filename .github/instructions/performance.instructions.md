---
description: 'The most comprehensive, practical, and engineer-authored performance optimization instructions for all languages, frameworks, and stacks. Covers frontend, backend, and database best practices with actionable guidance, scenario-based checklists, troubleshooting, and pro tips.'
---

# Performance Optimization Best Practices

## Introduction

Performance isn't just a buzzword—it's the difference between a product people love and one they abandon. I've seen firsthand how a slow app can frustrate users, rack up cloud bills, and even lose customers. This guide is a living collection of the most effective, real-world performance practices I've used and reviewed, covering frontend, backend, and database layers, as well as advanced topics. Use it as a reference, a checklist, and a source of inspiration for building fast, efficient, and scalable software.

---

## General Principles

- **Measure First, Optimize Second:** Always profile and measure before optimizing. Use benchmarks, profilers, and monitoring tools to identify real bottlenecks. Guessing is the enemy of performance.
  - *Pro Tip:* Use tools like Chrome DevTools, Lighthouse, New Relic, Datadog, Py-Spy, or your language's built-in profilers.
- **Optimize for the Common Case:** Focus on optimizing code paths that are most frequently executed. Don't waste time on rare edge cases unless they're critical.
- **Avoid Premature Optimization:** Write clear, maintainable code first; optimize only when necessary. Premature optimization can make code harder to read and maintain.
- **Minimize Resource Usage:** Use memory, CPU, network, and disk resources efficiently. Always ask: "Can this be done with less?"
- **Prefer Simplicity:** Simple algorithms and data structures are often faster and easier to optimize. Don't over-engineer.
- **Document Performance Assumptions:** Clearly comment on any code that is performance-critical or has non-obvious optimizations. Future maintainers (including you) will thank you.
- **Understand the Platform:** Know the performance characteristics of your language, framework, and runtime. What's fast in Python may be slow in JavaScript, and vice versa.
- **Automate Performance Testing:** Integrate performance tests and benchmarks into your CI/CD pipeline. Catch regressions early.
- **Set Performance Budgets:** Define acceptable limits for load time, memory usage, API latency, etc. Enforce them with automated checks.


---

## Frontend Performance

### Rendering and DOM
- **Minimize DOM Manipulations:** Batch updates where possible. Frequent DOM changes are expensive.
  - *Anti-pattern:* Updating the DOM in a loop. Instead, build a document fragment and append it once.
- **Virtual DOM Frameworks:** Use React, Vue, or similar efficiently—avoid unnecessary re-renders.
  - *React Example:* Use `React.memo`, `useMemo`, and `useCallback` to prevent unnecessary renders.
- **Keys in Lists:** Always use stable keys in lists to help virtual DOM diffing. Avoid using array indices as keys unless the list is static.
- **Avoid Inline Styles:** Inline styles can trigger layout thrashing. Prefer CSS classes.
- **CSS Animations:** Use CSS transitions/animations over JavaScript for smoother, GPU-accelerated effects.
- **Defer Non-Critical Rendering:** Use `requestIdleCallback` or similar to defer work until the browser is idle.

### Asset Optimization
- **Image Compression:** Use tools like ImageOptim, Squoosh, or TinyPNG. Prefer modern formats (WebP, AVIF) for web delivery.
- **SVGs for Icons:** SVGs scale well and are often smaller than PNGs for simple graphics.
- **Minification and Bundling:** Use Webpack, Rollup, or esbuild to bundle and minify JS/CSS. Enable tree-shaking to remove dead code.
- **Cache Headers:** Set long-lived cache headers for static assets. Use cache busting for updates.
- **Lazy Loading:** Use `loading="lazy"` for images, and dynamic imports for JS modules/components.
- **Font Optimization:** Use only the character sets you need. Subset fonts and use `font-display: swap`.

### Network Optimization
- **Reduce HTTP Requests:** Combine files, use image sprites, and inline critical CSS.
- **HTTP/2 and HTTP/3:** Enable these protocols for multiplexing and lower latency.
- **Client-Side Caching:** Use Service Workers, IndexedDB, and localStorage for offline and repeat visits.
- **CDNs:** Serve static assets from a CDN close to your users. Use multiple CDNs for redundancy.
- **Defer/Async Scripts:** Use `defer` or `async` for non-critical JS to avoid blocking rendering.
- **Preload and Prefetch:** Use `<link rel="preload">` and `<link rel="prefetch">` for critical resources.

### JavaScript Performance
- **Avoid Blocking the Main Thread:** Offload heavy computation to Web Workers.
- **Debounce/Throttle Events:** For scroll, resize, and input events, use debounce/throttle to limit handler frequency.
- **Memory Leaks:** Clean up event listeners, intervals, and DOM references. Use browser dev tools to check for detached nodes.
- **Efficient Data Structures:** Use Maps/Sets for lookups, TypedArrays for numeric data.
- **Avoid Global Variables:** Globals can cause memory leaks and unpredictable performance.
- **Avoid Deep Object Cloning:** Use shallow copies or libraries like lodash's `cloneDeep` only when necessary.

### Accessibility and Performance
- **Accessible Components:** Ensure ARIA updates are not excessive. Use semantic HTML for both accessibility and performance.
- **Screen Reader Performance:** Avoid rapid DOM updates that can overwhelm assistive tech.

### Framework-Specific Tips
#### React
- Use `React.memo`, `useMemo`, and `useCallback` to avoid unnecessary renders.
- Split large components and use code-splitting (`React.lazy`, `Suspense`).
- Avoid anonymous functions in render; they create new references on every render.
- Use `ErrorBoundary` to catch and handle errors gracefully.
- Profile with React DevTools Profiler.

#### Angular
- Use OnPush change detection for components that don't need frequent updates.
- Avoid complex expressions in templates; move logic to the component class.
- Use `trackBy` in `ngFor` for efficient list rendering.
- Lazy load modules and components with the Angular Router.
- Profile with Angular DevTools.

#### Vue
- Use computed properties over methods in templates for caching.
- Use `v-show` vs `v-if` appropriately (`v-show` is better for toggling visibility frequently).
- Lazy load components and routes with Vue Router.
- Profile with Vue Devtools.

### Common Frontend Pitfalls
- Loading large JS bundles on initial page load.
- Not compressing images or using outdated formats.
- Failing to clean up event listeners, causing memory leaks.
- Overusing third-party libraries for simple tasks.
- Ignoring mobile performance (test on real devices!).

### Frontend Troubleshooting
- Use Chrome DevTools' Performance tab to record and analyze slow frames.
- Use Lighthouse to audit performance and get actionable suggestions.
- Use WebPageTest for real-world load testing.
- Monitor Core Web Vitals (LCP, FID, CLS) for user-centric metrics.

---

## Code Review Checklist for Performance

- [ ] Are there any obvious algorithmic inefficiencies (O(n^2) or worse)?
- [ ] Are data structures appropriate for their use?
- [ ] Are there unnecessary computations or repeated work?
- [ ] Is caching used where appropriate, and is invalidation handled correctly?
- [ ] Are database queries optimized, indexed, and free of N+1 issues?
- [ ] Are large payloads paginated, streamed, or chunked?
- [ ] Are there any memory leaks or unbounded resource usage?
- [ ] Are network requests minimized, batched, and retried on failure?
- [ ] Are assets optimized, compressed, and served efficiently?
- [ ] Are there any blocking operations in hot paths?
- [ ] Is logging in hot paths minimized and structured?
- [ ] Are performance-critical code paths documented and tested?
- [ ] Are there automated tests or benchmarks for performance-sensitive code?
- [ ] Are there alerts for performance regressions?
- [ ] Are there any anti-patterns (e.g., SELECT *, blocking I/O, global variables)?

---

## Advanced Topics

### Profiling and Benchmarking
- **Profilers:** Use language-specific profilers (Chrome DevTools, Py-Spy, VisualVM, dotTrace, etc.) to identify bottlenecks.
- **Microbenchmarks:** Write microbenchmarks for critical code paths. Use `benchmark.js`, `pytest-benchmark`, or JMH for Java.
- **A/B Testing:** Measure real-world impact of optimizations with A/B or canary releases.
- **Continuous Performance Testing:** Integrate performance tests into CI/CD. Use tools like k6, Gatling, or Locust.

### Memory Management
- **Resource Cleanup:** Always release resources (files, sockets, DB connections) promptly.
- **Object Pooling:** Use for frequently created/destroyed objects (e.g., DB connections, threads).
- **Heap Monitoring:** Monitor heap usage and garbage collection. Tune GC settings for your workload.
- **Memory Leaks:** Use leak detection tools (Valgrind, LeakCanary, Chrome DevTools).

---

## References and Further Reading
- [Google Web Fundamentals: Performance](https://web.dev/performance/)
- [MDN Web Docs: Performance](https://developer.mozilla.org/en-US/docs/Web/Performance)
- [OWASP: Performance Testing](https://owasp.org/www-project-performance-testing/)
- [Microsoft Performance Best Practices](https://learn.microsoft.com/en-us/azure/architecture/best-practices/performance)
- [PostgreSQL Performance Optimization](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [MySQL Performance Tuning](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
- [Node.js Performance Best Practices](https://nodejs.org/en/docs/guides/simple-profiling/)
- [WebPageTest](https://www.webpagetest.org/)
- [Lighthouse](https://developers.google.com/web/tools/lighthouse)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [k6 Load Testing](https://k6.io/)
- [Gatling](https://gatling.io/)
- [Locust](https://locust.io/)
- [OpenTelemetry](https://opentelemetry.io/)
- [Jaeger](https://www.jaegertracing.io/)
- [Zipkin](https://zipkin.io/)

## Conclusion

Performance optimization is an ongoing process. Always measure, profile, and iterate. Use these best practices, checklists, and troubleshooting tips to guide your development and code reviews for high-performance, scalable, and efficient software. If you have new tips or lessons learned, add them here—let's keep this guide growing!

<!-- End of Performance Optimization Instructions -->
