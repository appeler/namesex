## Name Sex

Are men covered more often in business news than women? To answer the question and questions like these using text corpora, we need a way to infer gender based on the (first) name. In the US, one can easily infer the gender based on the first name using the data made available by the SSA and the Census. No such comparable data, however, exists for many other countries (and languages). 

With that a few caveats and notes:   
1. The gender distribution of a name changes over time, and by country.   
2. Some information about the gender associated with a name in countries (languages) where we don't have data may be recovered from SSA and Census data in US, and similar such data from other countries by exploiting the fact that these countries attract immigrants from various countries. For instance, one can infer gender of the name 'Gaurav' via [https://api.genderize.io/?name=gaurav](https://api.genderize.io/?name=gaurav).   
3. Other ways of getting gender of a name: see [clarifai gender](https://github.com/soodoku/clarifai_gender) that pairs Google Image search with AI to provide gender of a name. 
