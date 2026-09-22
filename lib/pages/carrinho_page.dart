import 'package:cart_test/models/carrinho.dart';
import 'package:cart_test/models/item_carrinho.dart';
import 'package:flutter/material.dart';

class CarrinhoPage extends StatefulWidget {
  final CarrinhoDeCompras carrinho;

  const CarrinhoPage({super.key, required this.carrinho});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  void _removerItem(String nome) {
    setState(() {
      widget.carrinho.removerItem(nome);
    });
  }

  void _limparCarrinho() {
    setState(() {
      widget.carrinho.limpar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final carrinho = widget.carrinho;

    final subtotal = carrinho.calcularSubtotal();

    final freteGratis = carrinho.temDireitoAFreteGratis();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho'),

        actions: [
          if (carrinho.itens.isNotEmpty)
            IconButton(
              tooltip: 'Limpar carrinho',
              onPressed: _limparCarrinho,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),

      body: carrinho.itens.isEmpty
          ? _buildCarrinhoVazio()
          : Column(
              children: [
                // ============================================
                // LISTA DE ITENS
                // ============================================
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: carrinho.itens.length,
                    itemBuilder: (context, index) {
                      final item = carrinho.itens[index];

                      return _buildItemCarrinho(item);
                    },
                  ),
                ),

                // ============================================
                // RESUMO
                // ============================================
                _buildResumo(subtotal, freteGratis),
              ],
            ),
    );
  }

  Widget _buildCarrinhoVazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),

            const SizedBox(height: 24),

            Text(
              'Seu carrinho está vazio',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            const Text(
              'Adicione alguns produtos para continuar.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Continuar comprando'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCarrinho(ItemCarrinho item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        leading: CircleAvatar(
          radius: 28,
          child: const Icon(Icons.inventory_2_outlined),
        ),

        title: Text(
          item.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${item.quantidade} x '
            'R\$ ${item.preco.toStringAsFixed(2)}',
          ),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'R\$ ${item.subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),

            const SizedBox(width: 8),

            IconButton(
              tooltip: 'Remover',
              onPressed: () {
                _removerItem(item.nome);
              },
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumo(double subtotal, bool freteGratis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,

        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),

      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // ================================================
            // SUBTOTAL
            // ================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal', style: TextStyle(fontSize: 17)),

                Text(
                  'R\$ ${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================================================
            // FRETE
            // ================================================
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface,
              ),

              child: Row(
                children: [
                  Icon(freteGratis ? Icons.local_shipping : Icons.info_outline),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      freteGratis
                          ? 'Parabéns! Você ganhou frete grátis.'
                          : 'Frete grátis para compras a partir de R\$ 150,00.',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================================================
            // FINALIZAR
            // ================================================
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compra finalizada!')),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Finalizar compra',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
