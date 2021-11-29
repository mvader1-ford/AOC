//
//  Day1.swift
//  test
//
//  Created by Dave DeLong on 11/28/21.
//  Copyright © 2021 Dave DeLong. All rights reserved.
//

//mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
//trh fvjkl sbzzf mxmxvkd (contains dairy)
//sqjhc fvjkl (contains soy)
//sqjhc mxmxvkd sbzzf (contains fish)

class Day1: Day {
    
    class IngredientAnalysis {
        
        let allIngredientCollections: [IngredientCollection]
        
        init(allIngredientCollections: [IngredientCollection]) {
            self.allIngredientCollections = allIngredientCollections
        }
        
        func allAllergens() -> Set<String> {
            let allIngredientsFound = allIngredientCollections.map{ $0.allergens }.flatMap{ $0 }
            
            return Set(allIngredientsFound)
        }
        
        func allMangledNames() -> Set<String> {
            let found = allIngredientCollections.map{ $0.mangledNames }.flatMap{ $0 }
            
            return Set(found)
        }
        
        func mangledNameCannotBeAllergenicForOne(mangledName: String, allergen: String) -> Bool {
            var answer = false
            for allIngredientCollection in allIngredientCollections.filter({ $0.containsAllergen(allergen)}) {
                let isAllergenPresentWithoutMangledName = allIngredientCollection.isAllergenPresentWithoutMangledName(allergen, mangledName)
                if isAllergenPresentWithoutMangledName {
                    answer = true
                }
            }

            return answer
        }
        
        func mangledCannotBeAllergenic(_ mangledName: String) -> Bool {
            var answer = false
            let allergens = allAllergens()
            for allergen in allergens {
                let local = mangledNameCannotBeAllergenicForOne(mangledName: mangledName, allergen: allergen)
                if local {
                    answer = true
                }
            }
            
            return answer
        }
        
        func cannotBeAllergenic() -> Set<String> {
            var answers = Set<String>()
            let mangledNames = allMangledNames()
            for mangledName in mangledNames {
                let local = mangledCannotBeAllergenic(mangledName)
                if local {
                    answers.insert(mangledName)
                }
            }
            
            return answers
        }
        
        func nonAllergenics() -> [String: Set<String>] {
            var misMatches = [String: Set<String>]()
            let mangledNames = allMangledNames()
            let allAllergens = allAllergens()
            for mangledName in mangledNames {
                var isAllergenPresentWithoutMangledName = false
                for allergen in allAllergens {
                    for allIngredientCollection in allIngredientCollections {
                        if allIngredientCollection.isAllergenPresentWithoutMangledName(allergen, mangledName) {
                         
                        } else {
                            isAllergenPresentWithoutMangledName = true
                            var misMatchesDetails = misMatches[mangledName] ?? []
                            misMatchesDetails.insert(allergen)
                            misMatches.updateValue(misMatchesDetails, forKey: mangledName)
                        }
                    }
                }
              
            }
            
            return misMatches
        }
        
        
    }
    
    class IngredientCollection {
        
        var allergens: Set<String> = []
        var mangledNames: Set<String> = []
        
        func containsAllergen(_ allergen: String) -> Bool {
            return allergen.contains(allergen)
        }
        
        func possibleThingsFor(ingredient: String) -> Set<String> {
            guard allergens.contains(ingredient) else { return [] }
            
            return mangledNames
        }
        
        func isAllergenPresentWithoutMangledName(_ allergen: String, _ mangledName: String) -> Bool {
            guard allergens.contains(allergen) else {
                return false
                
            }
            
            return mangledNames.contains(mangledName)
        }

    }
    
    func allIngredientCollections() -> [IngredientCollection] {
        let allergens = input.lines.map{ $0.raw.components(separatedBy: "(contains ") } //.prefix(upTo: "contains") }
        let part1 = allergens.compactMap(\.first)
        let allergensIngredients = allergens.compactMap(\.last).map{ $0.components(separatedBy: ",") }.map { $0.map{ $0.replacingOccurrences(of: ")", with: "").trimmed()}}
        let possibles = part1.map{ $0.components(separatedBy: .whitespaces).filter{ !$0.isEmpty } }
        let zFun = zip(possibles, allergensIngredients)
        var allItems = [IngredientCollection]()
        for (index, allergenThing) in allergensIngredients.enumerated() {
            let item = IngredientCollection()
            item.allergens = Set(allergenThing)
            item.mangledNames = Set(possibles[index])
            allItems.append(item)
        }
        
        return allItems
    }
    
    override func run() -> (String, String) {
        return super.run()
    }
    
    override func part1() -> String {
        let a1 = allIngredientCollections()
        let a2 = IngredientAnalysis(allIngredientCollections: a1)
        let a3 = a2.allAllergens()
        let a4 = a2.allMangledNames()
        let a5 = a2.nonAllergenics()
        let allergensCount = a3.count
        let answers = a2.cannotBeAllergenic()
        return "c"
    }
    
    override func part2() -> String {
        return "c"
    }
    
}
