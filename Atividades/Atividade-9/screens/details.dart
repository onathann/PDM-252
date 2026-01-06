import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final PostService apiService = PostService();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Post')),
      body: FutureBuilder<Post>(
        // AQUI ESTÁ A MÁGICA: Chamamos o método que busca UM só
        future: apiService.fetchPost(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final post = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: ${post.id}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 30),
                  const Divider(),
                  const Center(
                    child: Text('Dados carregados via GET /posts/id'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Post não encontrado.'));
          }
        },
      ),
    );
  }
}
