//
//  xmlParser.swift
//  SWAppTest
//
//  Created by Андрей Важенов on 25.08.2022.
//

import Foundation

class CurrensyParser: NSObject, XMLParserDelegate {
    private var currencies: [Currensy] = []
    private var currentElement = ""
    private var currentNumCode: String = ""
    private var currentCharCode: String = ""
    private var currentNominal: Int = 0
    private var currentName: String = ""{
        didSet{currentName = currentName.trimmingCharacters(in: CharacterSet.whitespaces)}
    }
    private var currentСurrencies: Double = 0
    private var parserCompletionHandler: (([Currensy])-> Void)?
    
    func parseСurrencies(url:String, completionHandler: (([Currensy])-> Void)?) {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                if let error = error{
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "Valute" {
            currentNumCode = ""
            currentCharCode = ""
            currentNominal = 0
            currentName = ""
            currentСurrencies = 0
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "NumCode":currentNumCode+=string
        case "CharCode": currentCharCode+=string
        case "Nominal": currentNominal = (string as NSString).integerValue
        case "Name": currentName += string
        case "Value": currentСurrencies = (string as NSString).doubleValue
        default: break
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Valute"
        {
            let valute = Currensy(numCode: currentNumCode, charCode: currentCharCode, nominal: currentNominal, name: currentName, value: currentСurrencies)
            self.currencies.append(valute)
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(currencies)
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
