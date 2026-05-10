import 'package:flutter/material.dart';
class CustomDropdown
    extends StatelessWidget {
  final String label;

  final String? selectedItem;

  final List<String> items;

  final void Function(String?)
  onChanged;

  final String? Function(String?)?
  validator;

  final IconData? prefixIcon;

  const CustomDropdown({

    super.key,

    required this.label,

    required this.selectedItem,

    required this.items,

    required this.onChanged,

    this.validator,

    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(

          label,

          style:
          Theme.of(context)
              .textTheme
              .labelMedium,
        ),

        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: selectedItem,

          validator: validator,

          onChanged: onChanged,

          decoration: InputDecoration(

            prefixIcon:
            prefixIcon != null

                ? Icon(prefixIcon)

                : null,

            border:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(14),
            ),

            enabledBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(14),

              borderSide:
              const BorderSide(
                color: Colors.grey,
              ),
            ),

            focusedBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(14),

              borderSide:
              const BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
          ),

          items: items.map(

                (value) {

              return DropdownMenuItem(

                value: value,

                child: Text(value),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}