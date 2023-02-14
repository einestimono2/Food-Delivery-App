import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../widgets/widgets.dart';

class ListCategories extends StatelessWidget {
  const ListCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionTitle(
          title: 'Category',
          firstTitle: true,
        ),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading || state is CategoryInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CategoryLoaded) {
              return Container(
                height: 100,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) => CategoryCard(
                    category: state.categories[index],
                  ),
                ),
              );
            } else if (state is CategoryError) {
              return Text(
                state.message,
                style: Theme.of(context).textTheme.headline3,
              );
            } else {
              return Text(
                "Something went wrong!",
                style: Theme.of(context).textTheme.headline3,
              );
            }
          },
        ),
      ],
    );
  }
}
