import 'package:cart_test/models/carrinho.dart';
import 'package:cart_test/models/item_carrinho.dart';
import 'package:cart_test/pages/carrinho_page.dart';
import 'package:flutter/material.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final CarrinhoDeCompras _carrinho = CarrinhoDeCompras();

  final List<ItemCarrinho> _produtos = [
    ItemCarrinho(nome: 'Notebook', preco: 3500.00),
    ItemCarrinho(nome: 'Mouse', preco: 120.00),
    ItemCarrinho(nome: 'Teclado', preco: 250.00),
    ItemCarrinho(nome: 'Headset', preco: 180.00),
    ItemCarrinho(nome: 'Webcam', preco: 220.00),
    ItemCarrinho(nome: 'Monitor', preco: 1200.00),
  ];

  void _adicionarItem(ItemCarrinho produto) {
    setState(() {
      _carrinho.adicionarItem(
        ItemCarrinho(nome: produto.nome, preco: produto.preco),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} adicionado ao carrinho.'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _abrirCarrinho() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarrinhoPage(carrinho: _carrinho),
      ),
    );

    // A tela de produtos é reconstruída quando
    // voltamos da tela do carrinho.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Flutter'),
        centerTitle: true,

        // ====================================================
        // ÍCONE DO CARRINHO
        // ====================================================
        actions: [
          Stack(
            children: [
              IconButton(
                tooltip: 'Carrinho',
                onPressed: _abrirCarrinho,
                icon: const Icon(Icons.shopping_cart_outlined),
              ),

              if (_carrinho.itens.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_carrinho.itens.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // ======================================================
      // CATÁLOGO
      // ======================================================
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Produtos', style: Theme.of(context).textTheme.headlineMedium),

          const SizedBox(height: 8),

          Text(
            'Escolha os produtos que deseja adicionar ao carrinho.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: 24),

          ..._produtos.map((produto) => _buildProdutoCard(produto)),
        ],
      ),
    );
  }

  Widget _buildProdutoCard(ItemCarrinho produto) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ==================================================
            // IMAGEM REPRESENTATIVA
            // ==================================================
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.inventory_2_outlined, size: 35),
            ),

            const SizedBox(width: 16),

            // ==================================================
            // INFORMAÇÕES
            // ==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'R\$ ${produto.preco.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // BOTÃO
            // ==================================================
            FilledButton(
              onPressed: () {
                _adicionarItem(produto);
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
