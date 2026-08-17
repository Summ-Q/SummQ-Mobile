import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_flutter/theme.dart';

Future<void> showDeckModal(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      final deckNameController = TextEditingController();
      PlatformFile? pickedFile;
      String? selectedFileName;
      return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: AppColors.cream,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Enter deck name ?",
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: deckNameController,
                      style: const TextStyle(color: AppColors.navy),
                      decoration: InputDecoration(
                        hintText: "...............................................",
                        filled: true,
                        fillColor: AppColors.gold,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final List<PlatformFile> files = await FilePicker.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if (files.isNotEmpty) {
                          final file = files.first;
                          setState(() {
                            pickedFile = file;
                            selectedFileName = file.name;
                          });
                        }
                      },
                      icon: const Icon(Icons.upload_file, color: AppColors.navy),
                      label: Text(
                        selectedFileName ?? "Upload PDF",
                        style: const TextStyle(color: AppColors.navy),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.navy),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Action Buttons (Done / Cancel)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (selectedFileName == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select a PDF first!")),
                              );
                              return;
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "PDF import is coming soon — use 'Paste Notes' for now.",
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            foregroundColor: AppColors.yellowLink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                          ),
                          child: const Text("Done", style: TextStyle(fontSize: 16)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            foregroundColor: AppColors.cream,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    },
  );
}