---
title: Start learning machine learning with jupyter notebook and Anaconda
date: 2017-08-02
preview_image: /images/iphone-desk-laptop-notebook.jpg
isIndex: False
disqus: True
---

To get started with learning Machine Learning, we want to focus on concept instead of programming languages or specific framework knowledges. So it's a good idea to use tools that most people use in community. And we are going to start using Jupyter and Anaconda today.

## Jupyter
When we learn date science or machine learning, we usually want to do some data exploration and fast feedback from running our data analysis. Jupyter is a great tool for that. In Jupyter, you can easily mix code and text, images, graphs and thus it's very common to use jupyter to create an report about your work and share it to others. And you can even host the jupyter notebook in cloud like AWS EC2 instance and start collaborating with your teammates.(like [here](https://medium.com/@amirziai/collaborating-with-jupyter-notebooks-40048e6628bd))

## Anaconda

If you come from developer background, you will probably know how important is using version & packager manager and it's also same in data science. Anaconda is built specific for data science which already come with hundreds of useful data science packages and `conda` which is a package and environment manager.


## Let's start

Download Anaconda from [here](https://www.continuum.io/downloads)

```bash
# start a new env for a new project
mkdir explore-iris && cd explore-iris
yes y |  conda create -n explore-iris python=3
# enter a environments
source activate explore-iris
yes y | conda install seaborn pandas jupyter notebook
```

Download Iris dataset from Kaggle [here](https://www.kaggle.com/uciml/iris). And unzip it and put to the data folder in our repository

```bash
jupyter notebook
```

This will open up the default browser. And you can see an web application and then click the top right button to create a new `.ipynb` file. And you start writing markdown or python code.

I had done some simple data exploration in Iris dataset. If you do not have much experience of data science in Python, feel free to clone my [repo](https://github.com/SWTPAIN/explore-iris).


Finally, it's always a good practice to export our package dependencies so other can easily get up and running with your project.

```bash
# Saving environments and export it as yaml file
conda env export > environment.yaml
# create a new environment by the yaml file
conda env create -f environment.yaml
```

## What now?
The best way to learn anything is by trying and learning from other. Kaggle is great place to learn from others. You can see other people code and discussion there. For the Iris dataset, you can click [here](https://www.kaggle.com/uciml/iris). Have fun!
