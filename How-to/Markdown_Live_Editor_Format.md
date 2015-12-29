#Hi#

This is a [Markdown][1] live editor built using [WMD][2] and other open source tools. I use it to write entries for my [posterous][3] blog and other places where Markdown is needed.

##Usage##

When you press the *copy markdown* button you'll get the markdown markup wrapped in `markdown` and `p` tags, so you can send it as an email to post@posterous.com to create a new entry for your own blog.

> *if your browser supports HTML 5, this text will be stored locally*

###Adding images###
![alt text][4]

###Writting code ###

    #!javascript
    function hi(){
        alert('hi!');
    }

To learn more about markdown click [here][5]

[1]: http://posterous.com/help/markdown
[2]: https://github.com/derobins/wmd
[3]: http://posterous.com
[4]: http://placehold.it/350x150
[5]: http://daringfireball.net/projects/markdown/



---
title: "Hello R Markdown"
output:
  html_document:
    css: faded.css
---

## Data

The `atmos` data set resides in the `nasaweather` package of the *R* programming language. It contains a collection of atmospheric variables measured between 1995 and 2000 on a grid of 576 coordinates in the western hemisphere. The data set comes from the [2006 ASA Data Expo](http://stat-computing.org/dataexpo/2006/).

Some of the variables in the `atmos` data set are:

* **temp** - The mean monthly air temperature near the surface of the Earth (measured in degrees kelvin (*K*))

* **pressure** - The mean monthly air pressure at the surface of the Earth (measured in millibars (*mb*))

* **ozone** - The mean monthly abundance of atmospheric ozone (measured in Dobson units (*DU*))

You can convert the temperature unit from Kelvin to Celsius with the formula

$$ celsius = kelvin - 273.15 $$

And you can convert the result to Fahrenheit with the formula

$$ fahrenheit = celsius \times \frac{5}{9} + 32 $$
  
```{r, echo = FALSE, results = 'hide'}
example_kelvin <- 282.15
```

For example, `r example_kelvin` degrees Kelvin corresponds to `r example_kelvin - 273.15` degrees Celsius.
