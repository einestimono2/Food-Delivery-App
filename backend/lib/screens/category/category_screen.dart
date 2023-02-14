
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../blocs/blocs.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = "/categories";
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isDeleted = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());
  }

  _deleteCategory(Category category) {
    setState(() {
      isDeleted = true;
    });
    context.read<CategoryBloc>().add(
          DeleteCategory(category: category),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdminScaffold(
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            showSnackBar(context, state.message);
            context.read<CategoryBloc>().add(LoadCategories());
          }

          // Show snack bar -- event delete
          if (isDeleted && state is CategoryLoaded) {
            showSnackBar(context, "Deleted the category!");
            setState(() {
              isDeleted = false;
            });
          }
        },
        builder: (context, state) {
          if (state is CategoryLoading || state is CategoryInitial) {
            return const CustomLoading();
          } else if (state is CategoryLoaded) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5)),
                        ),
                        child: Text(
                          "Categories",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 22,
                          ),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => const CategoryCard(),
                        ),
                        child: Text(
                          "+ ADD Category",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: MediaQuery.of(context).size.height * 0.025,
                      ),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: const <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth(flex: 1),
                          1: FlexColumnWidth(0.75),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(2),
                          4: IntrinsicColumnWidth(flex: 0.6),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          _buildHeader(),
                          ...state.categories
                              .map((category) => _buildRow(category))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                "Something went wrong!",
                style: Theme.of(context).textTheme.headline2,
              ),
            );
          }
        },
      ),
      route: CategoryScreen.routeName,
    );
  }

  Container _buildCell(String title, bool header) {
    final TextStyle headerText = Theme.of(context).textTheme.headline3!;
    final TextStyle cellText = Theme.of(context)
        .textTheme
        .headline4!
        .copyWith(fontWeight: FontWeight.normal);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(25),
      child: Text(
        title,
        style: header ? headerText : cellText,
      ),
    );
  }

  _buildHeader() => TableRow(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.15),
        ),
        children: <Widget>[
          _buildCell("ID", true),
          _buildCell("Image", true),
          _buildCell("Name", true),
          _buildCell("Description", true),
          _buildCell("Actions", true),
        ],
      );

  TableRow _buildRow(Category category) => TableRow(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.025),
        ),
        children: <Widget>[
          _buildCell(category.id!, false),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: AspectRatio(
              aspectRatio: 2 / 0.75,
              child: Image.network(category.image!, fit: BoxFit.contain),
            ),
          ),
          _buildCell(category.name, false),
          _buildCell(category.description, false),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => CategoryCard(
                    category: category,
                  ),
                ),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () => _deleteCategory(category),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      );
}
