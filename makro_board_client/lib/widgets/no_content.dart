import 'package:flutter/material.dart';

class NoContent extends StatelessWidget {
  final String label;
  final IconData iconData;
  final VoidCallback? addNewFunction;
  final String? addNewLabel;

  const NoContent({
    Key? key,
    required this.label,
    required this.iconData,
    this.addNewFunction,
    this.addNewLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          Icon(
            iconData,
            size: 256,
            color: Theme.of(context).primaryTextTheme.bodyLarge?.color ?? Theme.of(context).colorScheme.secondary,
          ),
          Column(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              if (addNewFunction != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: addNewFunction,
                    icon: const Icon(Icons.add, size: 64),
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        addNewLabel != null ? addNewLabel! : "Neu",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
