import 'package:cart_test/models/carrinho.dart';
import 'package:cart_test/models/item_carrinho.dart';
import 'package:flutter_test/flutter_test.dart';
// Suponha que seu projeto se chame "cart_test":

void main() {
  group('CarrinhoDeCompras', () {
    late CarrinhoDeCompras carrinho;

    // O setUp roda antes de CADA teste, garantindo um carrinho novo e vazio
    setUp(() {
      carrinho = CarrinhoDeCompras();
    });

    test('Deve iniciar com o carrinho vazio', () {
      // Assert
      expect(carrinho.itens, isEmpty);
      expect(carrinho.calcularSubtotal(), equals(0.0));
    });

    test('Deve adicionar itens ao carrinho com sucesso', () {
      // Arrange
      final item = ItemCarrinho(nome: 'Camiseta', preco: 49.90, quantidade: 2);

      // Act
      carrinho.adicionarItem(item);

      // Assert
      expect(carrinho.itens.length, equals(1));
      expect(carrinho.itens.first.nome, equals('Camiseta'));
      expect(carrinho.calcularSubtotal(), equals(99.80));
    });

    test('Deve remover item pelo nome corretamente', () {
      // Arrange
      final item1 = ItemCarrinho(nome: 'Teclado', preco: 120.0);
      final item2 = ItemCarrinho(nome: 'Mouse', preco: 80.0);
      carrinho.adicionarItem(item1);
      carrinho.adicionarItem(item2);

      // Act
      carrinho.removerItem('Teclado');

      // Assert
      expect(carrinho.itens.length, equals(1));
      expect(carrinho.itens.first.nome, equals('Mouse'));
      expect(carrinho.calcularSubtotal(), equals(80.0));
    });

    group('Cálculo de Desconto', () {
      test('Deve aplicar 10% de desconto corretamente', () {
        // Arrange
        carrinho.adicionarItem(ItemCarrinho(nome: 'Livro Dart', preco: 100.0));

        // Act
        final totalFinal = carrinho.calcularTotalComDesconto(
          percentualDesconto: 10,
        );

        // Assert
        expect(totalFinal, equals(90.0));
      });

      test('Deve lançar ArgumentError ao passar desconto inválido', () {
        // Arrange
        carrinho.adicionarItem(ItemCarrinho(nome: 'Livro', preco: 50.0));

        // Act & Assert
        // Para testar lançamento de exceções, passamos uma closure para o expect
        expect(
          () => carrinho.calcularTotalComDesconto(percentualDesconto: 110),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => carrinho.calcularTotalComDesconto(percentualDesconto: -5),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Frete Grátis', () {
      test('Não deve conceder frete grátis se subtotal for menor que 150', () {
        // Arrange
        carrinho.adicionarItem(ItemCarrinho(nome: 'Caneca', preco: 149.90));

        // Act & Assert
        expect(carrinho.temDireitoAFreteGratis(), isFalse);
      });

      test(
        'Deve conceder frete grátis se subtotal for exatamente 150 ou superior',
        () {
          // Arrange
          carrinho.adicionarItem(
            ItemCarrinho(nome: 'Fone Bluetooth', preco: 150.00),
          );

          // Act & Assert
          expect(carrinho.temDireitoAFreteGratis(), isTrue);
        },
      );
    });
  });

  group('ItemCarrinho', () {
    test('Deve lançar ArgumentError se preço for negativo', () {
      // Act & Assert
      expect(
        () => ItemCarrinho(nome: 'Item Inválido', preco: -10.0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Deve lançar ArgumentError se quantidade for zero ou negativa', () {
      // Act & Assert
      expect(
        () => ItemCarrinho(nome: 'Item Inválido', preco: 10.0, quantidade: 0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
