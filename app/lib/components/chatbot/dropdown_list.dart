import 'package:flutter/material.dart';

class DropdownList extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final Function(String) onItemSelected;

  const DropdownList({
    Key? key,
    required this.items,
    this.selectedValue,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 200, maxWidth: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: items.isEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'No items found',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey.shade100,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == selectedValue;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onItemSelected(item),
                      splashColor: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.1),
                      highlightColor: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.05),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.08)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade800,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}