---
title: Optimizing Expensive Javascript Function Application by Memorization
date: 2016-03-02
preview_image: /images/piano.jpeg
isIndex: False
---
There will be some occasion that you have some function that takes long processing time. And if the function is pure (no side-effect), we can use a simple technique called memoization to speed it up. The rational is basically creating a cache lookup table mapping arguments to result in order to avoid repeating the calculation of results for previously processed inputs.

Consider a naive implementation of fibonacci function.

```js
const fibonacci = n =>
  n < 2
    ? n
    : fibonacci(n-2) + fibonacci(n-1);
```
It will takes so long because of repeated calculation.

One simple memoized function is as follow.

```js
const memoized = fn => {  
  const lookupTable = {};

  return function(...args) {
    const key = JSON.stringify(this, args);

    return lookupTable[key] || (lookupTable[key] = fn.apply(this, args));
  }
}
const memoizedFibonacci = memoized( n =>  
  n < 2
    ? n
    : memoizedFibonacci(n-2) + memoizedFibonacci(n-1)
);
// Benchmarking
(()=> {
  console.time('before');
  fibonacci(40);
  console.timeEnd('before');
})(); // before: 63612.916ms
(()=> {
  console.time('after');
  memoizedFibonacci(40);
  console.timeEnd('after');
})() // after: 0.474ms
```
As you can see it takes much less time to obtain the result. By building a cache lookup table, we trade space for time and make our function.

Sometimes, we will want to set a limit on your cache size to prevent occupying too much memory. A naive implementation is as follow
```js
const createCache = limit => {  
  const entries = [];

  function get(key) {
    for (let index = 0; index < entries.length; index++) {
      const entry = entries[index];
      if (key === entry.key) {
        if (index > 0) {
          entries.splice(index, 1);
          entries.unshift(entry);
        }
        return entry.value;
      }
    }
  }

  function put(key, value) {
    if (!get(key)) {
      entries.unshift({key, value});
      if (entries.length > limit) {
        entries.pop();
      }
    }
  }

  return {get, put};
}

const memoized = limit => fn => {  
  const cache = createCache(limit);

  return function(...args) {
    const key = JSON.stringify(this, args);
    let value = cache.get(key);
    if (!value) {
      value = fn.apply(this, args)
    }
    cache.put(key, value);
    return value;
  }
}

// memoized result of latest 10 arguments
const memoizedFibonacci = memoized(10)( n =>  
  n < 2
    ? n
    : memoizedFibonacci(n-2) + memoizedFibonacci(n-1)
);
```

One of the use case in web application will be like some complex form validation. Please note that the above function heavily using closure in javascript. If you are not familiar with closure, you might want to have a look at the post I previously written [here](understanding-javascript-closure.html).
