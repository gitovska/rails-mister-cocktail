require 'faker'
require 'json'
require 'open-uri'
require 'pry-byebug'

Faker::UniqueGenerator.clear

def ingredient_getter
	rand_cocktail_url = open("https://www.thecocktaildb.com/api/json/v1/1/random.php").read
	rand_cocktail_json = JSON.parse(rand_cocktail_url)
	ingredients_json = rand_cocktail_json["drinks"][0]
	[ingredients_json["strIngredient1"], ingredients_json["strMeasure1"]]
end

puts "🍹 Generating Twin Peaks inspired Cocktails 🍹 "

1.times do
	flavour = Faker::Dessert.unique.flavor.split(" ")
	location = Faker::TvShows::TwinPeaks.unique.location.split(" ")
	beer = Faker::Beer.unique.style.split(" ")
	name = "#{beer.first} #{flavour.first} #{location.first}"
	#cocktail = Cocktail.create!({name: name})
	puts "🍸 Adding '#{name}' 🍸"
	cocktail_ingredients = {}
	2.times do
		ingredient_list = ingredient_getter
		cocktail_ingredients[ingredient_list[0]] = ingredient_list[1]
	end
	cocktail_ingredients.each do |ingredient, measure|
		if Ingredient.where(name: ingredient) == []
			puts "#{ingredient} doesn't exist"
			p Ingredient.where(name: ingredient)
			#cocktail_ingredient = Ingredient.create!({name: ingredient})
			#dose = Dose.create!({description: measure, cocktail_id: cocktail, ingredient_id: cocktail_ingredient})
		else
			puts "#{ingredient} exists"
			p Ingredient.where(name: ingredient)
			#dose = Dose.create!({description: measure, cocktail_id: cocktail, ingredient_id: Ingredient.where(name: ingredient)})
		end
		puts "#{dose.ingredient} #{dose.description}"
	end
	puts "****"
end
