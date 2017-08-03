---
title: Learning Machine Learning - Linear Regression
date: 2017-08-03
preview_image: /images/straight-road.jpeg
isIndex: False
disqus: True
---

## Introduction
There are two major categories of Machine Learning which are supervised and unsupervised learning. Linear regression is a very simple but useful supervised learning algorithmn. And we will use this as example and introduce two important thing in machine learning, **cost function** and **gradient descent**.


It's recommend to clone or see my jupyter notebookr result while reading this article. [here](https://github.com/SWTPAIN/linear-regression-intro)


### Linear Regression

In linear regression, our objective is to find the coefficients to fit best input and output in a linear function. The most intuitive example is drawing a single line in a x-y plane where x is input and y is the output. The ideal case will be all data points lies in  the straight line.


```
Multiple Linear Regression
y = theta_0 + theta_1 * x1 + theta_2 * x2 + … + theta_n * xn
```

In this example, we will work on a example to predict housing price and we will use two variables(apartment area and bedrooms count) as a simplest example of multiple linear regression.

### Feature Normalization
Before we start digging into regression, it's important to do feature normalization especially when we are using gradient descent. Otherwise, it can significant decrease the converging rate or even make it diverging.

```
x' = (x - mean_of_x) / (standard_deviration_of_x)
```

<br></br>

### Cost Function
We need to have a function to calculate how well our linear function fit the data and it will be simply mean squared error. So our objective is to minimize the cost by finding the optimal theta.

```
J(theta) = 1/(2m) * sum_(i=1)^m [ h_theta(x^i) - y^i ]^2
```

<br></br>

### Gradient Descent
Now we have cost function, we will use gradient descent to slowly adjust our theta until our cost is very low. The gradient is a rate of change of cost function so we will calculate the gradient and minus theta with the gradient in each iteration. For each step of gradient descent, our theta will become closer to the optimal values that lead to the lowest cost function **J(theta)**.

<br></br>

### Monitor convergence
While we are doing gradient descent, it's usually take some time to finish the program especially if we have lots of training data or number of iteration is very high. So, it's
suggested that we print our cost for each iteration and if it is not going down then it implies it's not converging and we should probably pause the program and check if there is any bug in it.

<br></br>

### References
- [Gradient Descent For Linear Regression in Coursera](https://www.coursera.org/learn/machine-learning/lecture/kCvQc/gradient-descent-for-linear-regression)
- [How to Do Linear Regression the Right Way ](https://www.youtube.com/watch?v=uwwWVAgJBcM)
