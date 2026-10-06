import 'package:cart_test/models/carrinho.dart';
import 'package:cart_test/models/item_carrinho.dart';
import 'package:cart_test/services/servico_frete.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Criação da classe de Mock utilizando o Mocktail.
// O Mock herda o comportamento e a assinatura de ServicoFrete.
class MockServicoFrete extends Mock implements ServicoFrete {}

void main() {
  group('CarrinhoDeCompras com Mocktail (Serviço de Frete)', () {
    late MockServicoFrete mockServicoFrete;
    late CarrinhoDeCompras carrinho;

    setUp(() {
      // Instanciamos o mock antes de cada teste
      mockServicoFrete = MockServicoFrete();

      // Injetamos o mock no CarrinhoDeCompras através do construtor
      carrinho = CarrinhoDeCompras(servicoFrete: mockServicoFrete);
    });

    test('Deve calcular o total somando o valor do frete retornado pelo Mock', () async {
      // Arrange (Preparação)
      carrinho.adicionarItem(ItemCarrinho(nome: 'Mouse', preco: 80.0));
      const cep = '01311-000';

      // Ensinamos o Mock o que fazer quando o método for chamado (Stubbing)
      when(() => mockServicoFrete.calcularFrete(cep))
          .thenAnswer((_) async => 25.0);

      // Act (Ação)
      final total = await carrinho.calcularTotalComFrete(cep);

      // Assert (Verificação de resultado e de chamadas)
      // Subtotal (80.0) + Frete Mockado (25.0) = 105.0
      expect(total, equals(105.0));

      // Verificamos se o método do mock foi chamado exatamente 1 vez com o CEP esperado
      verify(() => mockServicoFrete.calcularFrete(cep)).called(1);
    });

    test('NÃO deve chamar o serviço de frete quando tiver direito a frete grátis', () async {
      // Arrange (Preparação com subtotal >= 150)
      carrinho.adicionarItem(ItemCarrinho(nome: 'Monitor', preco: 200.0));
      const cep = '01311-000';

      // Act (Ação)
      final total = await carrinho.calcularTotalComFrete(cep);

      // Assert (Verificação)
      // Como o subtotal é 200.0 (>= 150.0), o total é 200.0 e o frete não é cobrado
      expect(total, equals(200.0));

      // Verificamos que o serviço externo de frete NUNCA foi chamado
      verifyNever(() => mockServicoFrete.calcularFrete(any()));
    });

    test('Deve aplicar desconto e calcular frete sobre o valor com desconto', () async {
      // Arrange
      carrinho.adicionarItem(ItemCarrinho(nome: 'Teclado', preco: 100.0));
      const cep = '01311-000';

      when(() => mockServicoFrete.calcularFrete(any()))
          .thenAnswer((_) async => 15.0);

      // Act (10% de desconto sobre 100.0 = 90.0; 90.0 < 150.0, portanto cobra frete)
      final total = await carrinho.calcularTotalComFrete(
        cep,
        percentualDesconto: 10,
      );

      // Assert: Subtotal com desconto (90.0) + Frete (15.0) = 105.0
      expect(total, equals(105.0));
      verify(() => mockServicoFrete.calcularFrete(cep)).called(1);
    });

    test('Deve propagar exceção quando o serviço de frete falhar', () async {
      // Arrange
      carrinho.adicionarItem(ItemCarrinho(nome: 'Cabo HDMI', preco: 30.0));
      const cepInvalido = '00000-000';

      // Simulamos um erro/exceção lançado pelo serviço externo
      when(() => mockServicoFrete.calcularFrete(cepInvalido))
          .thenThrow(ArgumentError('CEP não atendido.'));

      // Act & Assert
      expect(
        () => carrinho.calcularTotalComFrete(cepInvalido),
        throwsA(isA<ArgumentError>()),
      );

      verify(() => mockServicoFrete.calcularFrete(cepInvalido)).called(1);
    });
  });
}
