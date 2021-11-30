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
        
        var cleanIngredients = [String]()
        
        let allIngredientCollections: [IngredientCollection]
        
        func possibleMangledNamesMatchingFor() -> [String: Set<String>] {
            var possiblePatches = [String: Set<String>]()
            for allergen in allAllergens() {
                
                let affectedCollection = allIngredientCollections.filter{ $0.containsAllergen(allergen)}
                for allIngredientCollection in affectedCollection {
                    for mangledName in allIngredientCollection.mangledNames {
                        let count = affectedCollection.filter({ $0.mangledNames.contains(mangledName) }).count
                        if count == affectedCollection.count {
                            var currentMatches = possiblePatches[allergen] ?? []
                            currentMatches.insert(mangledName)
                            possiblePatches.updateValue(currentMatches, forKey: allergen)
                        }
                    }
                }
            }
            
            return possiblePatches
        }
        
        func showMeDangerCollections() -> [IngredientCollection] {
            allIngredientCollections.forEach { item in
                item.remove(clean: cleanIngredients)
            }
            let a = 123
            
            return allIngredientCollections
        }
        
        func howManyTimesDoTheyAppear() -> Int  {
            let stuff = thisDoesNotContainAny()
            var counter = 0
            let allIngredients = allIngredientCollections.map{ Array($0.mangledNames) }.flatMap{ $0 }
            for mangled in stuff {
                let matchCount = allIngredients.filter{ $0 == mangled }.count
                counter += matchCount
            }
            
            return counter
        }
        
        func thisDoesNotContainAny() -> Set<String> {
            var allStuff = Set<String>()
            var allGo = Set(allMangledNames())
            for allergen in allAllergens() {
                let match = thisDoesNotContain(allergen: allergen)
                allGo = allGo.intersection(match)
            }
            cleanIngredients = Array(allGo)
            
            return allGo
            
        }
        
        func thisDoesNotContain(allergen: String) -> Set<String> {
            var goSet = Set<String>()
            let mangledNameLists = allIngredientCollections.filter{ $0.containsAllergen(allergen) }.map { $0.mangledNames }
            let pairCount = mangledNameLists.count
            for matchingMangled in allMangledNames() {
                let matchCount = mangledNameLists.filter{ $0.contains(matchingMangled) }.count
                if matchCount != pairCount {
                    goSet.insert(matchingMangled)
                }
            }
            
            return goSet
        }
        
        func allergenCannotBeCausedByAny() -> [String] {
            var cannotBeCausedBy = [String]()
            for allergen in allAllergens() {
                let check1 = allergenCannotBeCausedByOneOfThese(allergen: allergen)
                cannotBeCausedBy = cannotBeCausedBy + check1
            }
            
            let count1 = allAllergens().count
            var realAnswer = [String]()
            for allergen in allAllergens() {
                let countFound = cannotBeCausedBy.filter{ $0 == allergen }.count
                if countFound == count1 {
                    realAnswer.append(allergen)
                }
            }
            
            
            return realAnswer
        }
        
        func allergenCannotBeCausedByOneOfThese(allergen: String) -> Set<String> {
            let mustBeList = allergenMustBeCausedByOneOfThese(allergen: allergen)
            let mangledNames = Array(allIngredientCollections.map{ $0.mangledNames })
            let answer = allMangledNames().filter{ !mustBeList.contains($0)}
            
            return answer
        }
        
        func allergenMustBeCausedByOneOfThese(allergen: String) -> Set<String> {
            let affectedGroup = allIngredientCollections.filter({ $0.containsAllergen(allergen)})
            let mangledNamesInThoseGroups = affectedGroup.map{ $0.mangledNames }.flatMap{ $0 }
            
            return Set(mangledNamesInThoseGroups)
        }
        
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
        
        func remove(clean: [String]) {
            mangledNames = mangledNames.filter{ !clean.contains($0) }
        }
        
        func containsAllergen(_ allergen: String) -> Bool {
            return allergens.contains(allergen)
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
        let cFound = a2.howManyTimesDoTheyAppear()
        
        return String(cFound)
    }
    
    var didProcess = [String]()
    //  kpsdtv
    func assessFunStuff(groups1: [String: Set<String>]) -> [String: String] {
        var oneCheck = true

        let possibleUnused = groups1.filter{ !didProcess.contains($0.0) }
        let allRemaining = possibleUnused.map{ $0.1 }.flatMap{ $0 }
        var useThisOne = ""
     
        for (key, value) in possibleUnused {
            for item in value {
                if allRemaining.filter({ $0 == item }).count == 1 {
                    if oneCheck {
                        useThisOne = item
                        didProcess.append(key)
                        oneCheck = false
                    }
                }
            }
        
        }
        
        guard useThisOne != "" else {
            var allDone = [String: String]()
            let finalGroups = groups1
            for group in finalGroups {
                allDone.updateValue(group.1.first!, forKey: group.0)
            }
            
            return allDone
        }
        
        var myGroups = groups1
        let singleItem = useThisOne
        
        for myGroup in groups1 {
            if myGroup.1.contains(singleItem) && myGroup.1.count > 1 {
                let theValues = myGroup.1.filter{ $0 == singleItem }
                myGroups.updateValue(theValues, forKey: myGroup.0)
            }
        }
        if myGroups.filter({ $0.1.count == 1 }).count == myGroups.count {
            var allDone = [String: String]()
            for group in myGroups {
                allDone.updateValue(group.1.first!, forKey: group.0)
            }
            
            return allDone
        } else {
            return assessFunStuff(groups1: myGroups)
        }
    }
    
    override func part2() -> String {
        let a1 = allIngredientCollections()
        let a2 = IngredientAnalysis(allIngredientCollections: a1)
        let cFound = a2.howManyTimesDoTheyAppear()
        
        let c3 = a2.possibleMangledNamesMatchingFor()
        let c5 = assessFunStuff(groups1: c3)
        
        let sortedArray = c5.keys.sorted()
        
        let finalValues = sortedArray.map{ c5[$0]! }
        
        let answer = finalValues.joined(separator: ",")
        return answer
    }
    
}
