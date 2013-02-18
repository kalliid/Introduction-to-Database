(:***************************************************************
Q1 Return the area of Mongolia. 
***************************************************************:)
doc("countries.xml")/countries/country[@name="Mongolia"]/data(@area)

(:***************************************************************
Q2 Return the names of all cities that have the same name as the country in which they are located.
***************************************************************:)
for $a in doc("countries.xml")//country
for $c in $a/city
where $a/@name = $c/name
return $c/name

(:***************************************************************
Q3 Return the average population of Russian-speaking countries. 
***************************************************************:)
avg(doc("countries.xml")/countries/country[language="Russian"]/data(@population))

(:***************************************************************
Q4 Return the names of all countries where over 50% of the population speaks German. (Hint: Depending on your solution, you may want to use ".", which refers to the "current element" within an XPath expression.) 
***************************************************************:)
doc("countries.xml")//country/language[contains(.,"German") and data(@percentage)>50]/../data(@name)

(:***************************************************************
Q5 Return the name of the country with the highest population. (Hint: You may need to explicitly cast population numbers as integers with xs:int() to get the correct answer. )
***************************************************************:)
for $a in doc("countries.xml")//country
where $a/xs:int(data(@population)) = max(doc("countries.xml")//country/xs:int(data(@population)))
return $a/data(@name)
