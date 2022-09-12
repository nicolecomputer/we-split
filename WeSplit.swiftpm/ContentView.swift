import SwiftUI

struct ContentView: View {
    // Mutable State
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20
    @State private var shouldSplit = true
    @State private var roundUp = false
    
    // Constant
    let tipPercentages = [10, 15, 20, 25, 0]
    
    // Computed properties–
    var splitTheBillAmongstPeople: Int {
        if !shouldSplit {
            return 1
        }
        
        return numberOfPeople + 2
    }
    var grandTotal: Double {
        if checkAmount == 0 {
            return 0
        }
        
        let grandTotal = checkAmount + tipAmount
        
        return grandTotal
    }
    
    var tipAmount: Double {
        let baseTip = checkAmount / 100 * Double(tipPercentage)
        if roundUp && tipPercentage > 0 {
            let total = checkAmount + baseTip
            let roundedUp = total.rounded(.up)
            return baseTip + (roundedUp - total)
        }
        return baseTip
    }
    
    var totalPerPerson: Double {
        return grandTotal / Double(splitTheBillAmongstPeople)
    }
    
    var currencyFormat: FloatingPointFormatStyle<Double>.Currency {
        return .currency(code: Locale.current.currencyCode ?? "USD")
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section("Bill Total") {
                        TextField(
                            "Amount", 
                            value: $checkAmount, 
                            format: self.currencyFormat)
                        .keyboardType(.decimalPad)
                    }
                    
                    Section("Tip") {
                        Picker("Tip Percecntage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                        if tipPercentage > 0 {
                            Toggle("Round Up", isOn: $roundUp)
                        }
                    }
                        
                    Section("Split"){
                        Toggle("Split the bill", isOn: $shouldSplit)
                        
                        if shouldSplit {
                            Picker("Number of People", selection: $numberOfPeople) {
                                ForEach(2..<100) { people in
                                    Text("\(people) people")
                                }
                            }
                        }
                    }
                }
                
                Form {
                    Section("Tip"){
                        Text(tipAmount, format: self.currencyFormat)
                    }
                    
                    Section("Grand Total") {
                        Text(grandTotal, format: self.currencyFormat)
                    }
                    
                    if shouldSplit {
                        Section("Per Person") {
                            Text(totalPerPerson, format: self.currencyFormat)
                        }
                    }
                }
                .background(Color.black)
                .cornerRadius(20)
                .padding()
                
            }
            .navigationTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
