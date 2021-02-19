require 'faker'
require 'json'

Faker::UniqueGenerator.clear

def random_cocktail
	rand_cocktail_url = open("https://www.thecocktaildb.com/api/json/v1/1/random.php").read
	rand_cocktail_json = JSON.parse(rand_cocktail_url)
	rand_cocktail_json["drinks"][0]
end

def ingredient_getter
	begin
		ingredients_json = random_cocktail
		ingredient_array = [ingredients_json["strIngredient1"], ingredients_json["strMeasure1"]]
	end while ingredient_array[0].nil? || ingredient_array[1].nil?
	ingredient_array.map { |ingredient| ingredient.strip }
end

def ingredient_builder(amount)
	cocktail_ingredients = {}
	amount.times do
		begin
		ingredient_array = ingredient_getter
		end while cocktail_ingredients.include?(ingredient_array[0])
		cocktail_ingredients[ingredient_array[0]] = ingredient_array[1]
	end
	cocktail_ingredients
end

def cocktail_builder(cocktail_amount, ingredient_amount)
	puts "🍹 Generating Twin Peaks inspired Cocktails 🍹 "

	cocktail_amount.times do
		flavour = Faker::Dessert.unique.flavor.split(" ")
		location = Faker::TvShows::TwinPeaks.unique.location.split(" ")
		beer = Faker::Beer.unique.style.split(" ")
		name = "#{beer.first} #{flavour.first} #{location.first}"
		cocktail = Cocktail.create!({name: name})
		cocktail_ingredients = ingredient_builder(ingredient_amount)
		cocktail_ingredients.each do |ingredient, measure|
			unless Ingredient.where(name: ingredient).any?
				cocktail_ingredient = Ingredient.create!({name: ingredient})
				dose = Dose.create!({description: measure,
							cocktail: cocktail,
							ingredient: cocktail_ingredient})
			else
				dose = Dose.create!({description: measure,
							cocktail: cocktail,
							ingredient: Ingredient.find_by(name: ingredient)})
			end
		end
		puts "\n🍸 Added '#{cocktail.name}' 🍸"
		cocktail.doses.each_with_index do |dose, index|
			puts "#{index + 1}. #{dose.ingredient.name} (#{dose.description})"
		end
	end
end

cocktail_builder(10, 6)