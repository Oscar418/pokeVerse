//
//  PokiVerseTests.swift
//  PokiVerseTests
//
//  Created by Ndamu Nengovhela on 2024/02/04.
//

import XCTest

@testable import PokiVerse
final class PokiVerseTests: XCTestCase {
    
    var detailViewModel: DetailViewModel!
    var homeViewModel: HomeViewModel!
    var mockPokeRepo: MockPokeRepo!
    
    override func setUp() {
        super.setUp()
        mockPokeRepo = MockPokeRepo()
        detailViewModel = DetailViewModel(pokeRepo: mockPokeRepo)
        homeViewModel = HomeViewModel(pokeRepo: mockPokeRepo)
    }
    
    override func tearDown() {
        super.tearDown()
        detailViewModel = nil
        mockPokeRepo = nil
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPokemonDetailInitialization() {
        let stat = Stat(name: "Ivysaur")
        let pokeStat = PokeStat(base_stat: 100, stat: stat)
        let sprite = Sprite(front_shiny: "sprite_url")
        
        let pokemonDetail = PokemonDetail(id: 1, height: 10, weight: 100, stats: [pokeStat], sprites: sprite)
        
        XCTAssertEqual(pokemonDetail.id, 1)
        XCTAssertEqual(pokemonDetail.height, 10)
        XCTAssertEqual(pokemonDetail.weight, 100)
        XCTAssertEqual(pokemonDetail.stats.count, 1)
        XCTAssertEqual(pokemonDetail.stats[0].base_stat, 100)
        XCTAssertEqual(pokemonDetail.sprites.front_shiny, "sprite_url")
    }
    
    func testFormatNumber() {
        let value = 25
        let formattedString = MeasurementsUtil.formatNumber(value: value, factor: 10)
        XCTAssertEqual(formattedString, "2.50")
    }
    
    func testFormatWeight() {
        detailViewModel.pokemonDetails = PokemonDetail(id: 1, height: 10, weight: 100, stats: [], sprites: Sprite(front_shiny: ""))
        let formattedWeight = detailViewModel.formatNumber(value: detailViewModel.pokemonDetails?.weight ?? 0)
        XCTAssertEqual(formattedWeight, "10.00")
    }

    func testGetDetailsSuccess() {
        let mockPokemon = Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25")
        let mockPokemonDetail = PokemonDetail(id: 25, height: 40, weight: 60, stats: [], sprites: Sprite(front_shiny: ""))
        mockPokeRepo.expectedPokemonDetail = mockPokemonDetail
        let expectation = XCTestExpectation(description: "Loading data")
        detailViewModel.getDetails(pokemon: mockPokemon)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            XCTAssertFalse(self.detailViewModel.isLoading)
            XCTAssertEqual(self.detailViewModel.errorMessage, "")
            XCTAssertFalse(self.detailViewModel.showAlert)
            XCTAssertEqual(self.detailViewModel.pokemonDetails, mockPokemonDetail)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetDetailsFailure() {
        let mockPokemon = Pokemon(name: "InvalidPokemon", url: "https://pokeapi.co/api/v2/pokemon/999")
        let errorMessage = "Failed to fetch Pokemon details."
        mockPokeRepo.expectedError = errorMessage
        let expectation = XCTestExpectation(description: "Loading data")
        detailViewModel.getDetails(pokemon: mockPokemon)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            XCTAssertFalse(self.detailViewModel.isLoading)
            XCTAssertEqual(self.detailViewModel.errorMessage, errorMessage)
            XCTAssertTrue(self.detailViewModel.showAlert)
            XCTAssertNil(self.detailViewModel.pokemonDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetPokemonsSuccess() {
        let mockPokemonList = PokemonResults(count: 3, results: [
            Pokemon(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/25"),
            Pokemon(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1"),
            Pokemon(name: "Charmander", url: "https://pokeapi.co/api/v2/pokemon/4")
        ])
        mockPokeRepo.expectedPokemonList = mockPokemonList
        let expectation = XCTestExpectation(description: "Loading data")
        homeViewModel.getPokemons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            XCTAssertFalse(self.homeViewModel.isLoading)
            XCTAssertEqual(self.homeViewModel.errorMessage, "")
            XCTAssertFalse(self.homeViewModel.showAlert)
            XCTAssertEqual(self.homeViewModel.pokemonList, mockPokemonList.results)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetPokemonsFailure() {
        let errorMessage = "Failed to fetch Pokemon list."
        mockPokeRepo.expectedError = errorMessage
        let expectation = XCTestExpectation(description: "Loading data")
        homeViewModel.getPokemons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            XCTAssertFalse(self.homeViewModel.isLoading)
            XCTAssertEqual(self.homeViewModel.errorMessage, errorMessage)
            XCTAssertTrue(self.homeViewModel.showAlert)
            XCTAssertEqual(self.homeViewModel.pokemonList, [])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}

final class MockPokeRepo: RestPokeRepository {
    var expectedPokemonDetail: PokemonDetail?
    var expectedPokemonList: PokemonResults?
    var expectedError: String?
    
    override func getDetailedPokemon(id: Int, completion: @escaping (PokemonDetail) -> Void, failure: @escaping (String) -> Void) {
        if let pokemonDetail = expectedPokemonDetail {
            completion(pokemonDetail)
        } else if let error = expectedError {
            failure(error)
        }
    }
    
    override func getPokemons(completion: @escaping (PokemonResults) -> Void, failure: @escaping (String) -> Void) {
        if let pokemonList = expectedPokemonList {
            completion(pokemonList)
        } else if let error = expectedError {
            failure(error)
        }
    }
}
