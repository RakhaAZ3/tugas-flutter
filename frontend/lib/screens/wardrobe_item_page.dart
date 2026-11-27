
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/outfit_model.dart';
import '../models/wardrobe_item_model.dart';
import '../services/outfit_service.dart';
import '../services/wardrobe_item_service.dart';

class WardrobeItemPage extends StatefulWidget {
  final Outfit outfit;

  const WardrobeItemPage({
    super.key,
    required this.outfit,
  });

  @override
  State<WardrobeItemPage> createState() => _WardrobeItemPageState();
}

class _WardrobeItemPageState extends State<WardrobeItemPage> {
  static const Color navy = Color(0xFF172554);
  static const Color blue = Color(0xFF2563EB);
  static const Color background = Color(0xFFF5F7FC);

  final WardrobeItemService itemService = WardrobeItemService();
  final OutfitService outfitService = OutfitService();

  List<WardrobeItem> items = [];
  List<Outfit> outfits = [];

  int? selectedFilterId;
  bool isLoading = true;

  List<WardrobeItem> get filteredItems {
    if (selectedFilterId == null) {
      return items;
    }

    return items
        .where((item) => item.outfitId == selectedFilterId)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // MEMUAT DATA ITEM DAN KATEGORI
  Future<void> loadData() async {
    setState(() => isLoading = true);

    try {
      final itemData = await itemService.getItems();
      final outfitData = await outfitService.getOutfits();

      final loadedItems = itemData
          .map((item) => WardrobeItem.fromJson(item))
          .toList();

      if (!mounted) return;

      setState(() {
        items = loadedItems;
        outfits = outfitData;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // FORM TAMBAH DAN EDIT ITEM
  Future<void> showItemDialog({WardrobeItem? item}) async {
    if (outfits.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan kategori terlebih dahulu'),
        ),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController(
      text: item?.title ?? '',
    );

    final priceController = TextEditingController(
      text: item?.price?.toStringAsFixed(0) ?? '',
    );

    final colorController = TextEditingController(
      text: item?.color ?? '',
    );

    final imageController = TextEditingController(
      text: item?.imageUrl ?? '',
    );

    final notesController = TextEditingController(
      text: item?.notes ?? '',
    );

    int selectedOutfitId = outfits.any(
      (outfit) => outfit.id == (item?.outfitId ?? widget.outfit.id),
    )
        ? (item?.outfitId ?? widget.outfit.id)
        : outfits.first.id;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                item == null ? 'Tambah Item' : 'Edit Item',
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildInput(
                        controller: titleController,
                        label: 'Nama Produk',
                        icon: Icons.checkroom_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama produk wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      buildInput(
                        controller: priceController,
                        label: 'Harga',
                        icon: Icons.payments_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),

                      const SizedBox(height: 12),

                      buildInput(
                        controller: colorController,
                        label: 'Warna',
                        icon: Icons.palette_outlined,
                      ),

                      const SizedBox(height: 12),

                      buildInput(
                        controller: imageController,
                        label: 'URL Gambar',
                        icon: Icons.image_outlined,
                      ),

                      const SizedBox(height: 12),

                      buildInput(
                        controller: notesController,
                        label: 'Catatan',
                        icon: Icons.notes_outlined,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 16),

                      // DROPDOWN DARI TABEL 1
                      DropdownButtonFormField<int>(
                        initialValue: selectedOutfitId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Pilih Kategori',
                          prefixIcon: const Icon(
                            Icons.category_outlined,
                            color: blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: outfits.map((outfit) {
                          return DropdownMenuItem<int>(
                            value: outfit.id,
                            child: Text(outfit.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedOutfitId = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Kategori wajib dipilih';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogContext, true);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true) {
      titleController.dispose();
      priceController.dispose();
      colorController.dispose();
      imageController.dispose();
      notesController.dispose();
      return;
    }

    try {
      final price = priceController.text.trim().isEmpty
          ? null
          : double.tryParse(priceController.text.trim());

      if (priceController.text.trim().isNotEmpty && price == null) {
        throw Exception('Harga tidak valid');
      }

      if (item == null) {
        await itemService.addItem(
          outfitId: selectedOutfitId,
          title: titleController.text.trim(),
          price: price,
          color: colorController.text.trim(),
          imageUrl: imageController.text.trim().isEmpty
              ? null
              : imageController.text.trim(),
          notes: notesController.text.trim(),
        );
      } else {
        await itemService.updateItem(
          item.id,
          outfitId: selectedOutfitId,
          title: titleController.text.trim(),
          price: price,
          color: colorController.text.trim(),
          imageUrl: imageController.text.trim().isEmpty
              ? null
              : imageController.text.trim(),
          notes: notesController.text.trim(),
        );
      }

      if (!mounted) return;

      await loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            item == null
                ? 'Item berhasil ditambahkan'
                : 'Item berhasil diperbarui',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      titleController.dispose();
      priceController.dispose();
      colorController.dispose();
      imageController.dispose();
      notesController.dispose();
    }
  }

  // INPUT FORM
  Widget buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: blue),
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // HAPUS ITEM
  Future<void> deleteItem(WardrobeItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Hapus Item?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus ${item.title}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await itemService.deleteItem(item.id);

      if (!mounted) return;

      await loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // PLACEHOLDER GAMBAR
  Widget imagePlaceholder() {
    return Container(
      width: 65,
      height: 65,
      color: const Color(0xFFEFF3FA),
      child: const Icon(
        Icons.checkroom,
        color: blue,
        size: 30,
      ),
    );
  }

  // TAMPILAN ITEM
  Widget buildItemCard(WardrobeItem item) {
    final outfit = outfits.where(
      (outfit) => outfit.id == item.outfitId,
    );

    final categoryName = outfit.isNotEmpty
        ? outfit.first.name
        : 'Kategori tidak ditemukan';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: item.imageUrl != null &&
                  item.imageUrl!.isNotEmpty
              ? Image.network(
                  item.imageUrl!,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    return imagePlaceholder();
                  },
                )
              : imagePlaceholder(),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rp${item.price?.toStringAsFixed(0) ?? '0'}',
                style: const TextStyle(
                  color: blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Warna: ${item.color?.isNotEmpty == true ? item.color : '-'}',
              ),
              Text('Kategori: $categoryName'),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: navy),
          onSelected: (value) {
            if (value == 'edit') {
              showItemDialog(item: item);
            } else if (value == 'delete') {
              deleteItem(item);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 19),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 19,
                  ),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedItems = filteredItems;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        elevation: 0,
        title: const Text(
          'Manajemen Item Koleksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: loadData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: outfits.isEmpty ? null : () => showItemDialog(),
        backgroundColor: blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Item'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: blue),
            )
          : RefreshIndicator(
              onRefresh: loadData,
              color: blue,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // HEADER
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [navy, blue],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                          size: 38,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Koleksi Saya',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${items.length} item tersimpan',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // FILTER KATEGORI
                  const Text(
                    'Filter Kategori',
                    style: TextStyle(
                      color: navy,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: selectedFilterId,
                        isExpanded: true,
                        hint: const Text('Pilih Kategori'),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('Semua Kategori'),
                          ),
                          ...outfits.map((outfit) {
                            return DropdownMenuItem<int?>(
                              value: outfit.id,
                              child: Text(outfit.name),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedFilterId = value;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // JUDUL DAFTAR ITEM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar Item',
                        style: TextStyle(
                          color: navy,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${displayedItems.length} item',
                        style: const TextStyle(
                          color: blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // DAFTAR ITEM
                  if (displayedItems.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 55),
                      child: Column(
                        children: [
                          Icon(
                            Icons.checkroom_outlined,
                            size: 75,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Belum Ada Item',
                            style: TextStyle(
                              color: navy,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            items.isEmpty
                                ? 'Silakan tambahkan item pakaian.'
                                : 'Tidak ada item pada kategori ini.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...displayedItems.map(buildItemCard),

                  const SizedBox(height: 85),
                ],
              ),
            ),
    );
  }
}
