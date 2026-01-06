import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import 'details.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final PostService apiService = PostService();
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Posts')),

      // --- BOTÃO DE ADICIONAR (CREATE) ---
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Criamos um post fake para teste
          Post novoPost = Post(
            userId: 1,
            id: 0,
            title: 'Novo Post',
            body: 'Criado pelo App',
          );

          try {
            // Chama o serviço
            Post postCriado = await apiService.createPost(novoPost);

            // Feedback visual
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Post criado! ID: ${postCriado.id} (Fake)'),
                ),
              );
            }
            // OBS: Como a API é fake, ela não salva de verdade,
            // então não adianta recarregar a lista aqui.
          } catch (e) {
            print(e);
          }
        },
      ),

      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;

            return ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final post = posts[index];

                return ListTile(
                  title: Text(
                    post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Toque para ver detalhes'),

                  // --- CLIQUE PARA EDITAR (UPDATE) ---
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(postId: post.id),
                      ),
                    );
                  },

                  onLongPress: () async {
                    Post postEditado = Post(
                      userId: post.userId,
                      id: post.id,
                      title: '${post.title} (Editado)',
                      body: post.body,
                    );
                    await apiService.updatePost(postEditado);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Post atualizado (PUT)!')),
                      );
                    }
                    setState(() {
                      posts[index] = postEditado;
                    });
                  },

                  // --- BOTÃO DE DELETAR (DELETE) ---
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await apiService.deletePost(post.id);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post deletado!')),
                        );
                      }

                      // Removemos visualmente da lista (já que a API não remove de verdade)
                      setState(() {
                        posts.removeAt(index);
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Sem dados.'));
          }
        },
      ),
    );
  }
}
