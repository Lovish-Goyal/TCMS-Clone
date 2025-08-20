// import 'package:flutter/material.dart';

// class MyCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String title;
//   final bool isSearchIconVisible;
//   final dynamic bloc;
//   final Function(String query)? onSearch;
//   final List<IconButton>? actions;

//   const MyCustomAppBar({
//     super.key,
//     required this.title,
//     this.isSearchIconVisible = true,
//     this.actions,
//     this.bloc,
//     this.onSearch,
//   });

//   @override
//   State<MyCustomAppBar> createState() => _MyCustomAppBarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

// class _MyCustomAppBarState extends State<MyCustomAppBar> {
//   bool isSearchFieldVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//         backgroundColor: Colors.blue,
//         centerTitle: false,
//         leading: IconButton(
//             onPressed: () {
//               if (isSearchFieldVisible) {
//                 setState(() {
//                   isSearchFieldVisible = false;
//                 });
//                 context.read<BatchBloc>().add(SearchBatchEvent(''));
//               } else {
//                 context.pop();
//               }
//             },
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             )),
//         title: isSearchFieldVisible
//             ? SearchTextField(
//                 context: context,
//                 onSearch: ({required String val}) {
//                   widget.bloc.add(widget.onSearch!(val));
//                   // context.read<StudentBloc>().add(
//                   //       GetSearchedStudentListEvent(
//                   //         studentName: val, isActive: true,
//                   //         // batches,
//                   //       ),
//                   //     );
//                 })
//             : Text(widget.title),
//         actions: [
//           if (widget.isSearchIconVisible)
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   isSearchFieldVisible = !isSearchFieldVisible;
//                 });
//                 if (!isSearchFieldVisible) {
//                   switch (widget.bloc) {
//                     case BatchBloc _:
//                       context.read<BatchBloc>().add(SearchBatchEvent(''));
//                       break;
//                     case StudentBloc _:
//                       context.read<StudentBloc>().add(GetStudentListEvent());
//                       break;
//                   }
//                   // context.read<BatchBloc>().add(SearchBatchEvent(''));

//                   // widget.bloc.add(GetStudentListEvent());
//                 }
//               },
//               icon: Icon(
//                 isSearchFieldVisible ? Icons.close : Icons.search,
//                 color: Colors.white,
//               ),
//               iconSize: 35,
//             ),
//           if (widget.actions != null) ...widget.actions!,
//         ]
//         // if (widget.isSearchIconVisible)
//         );
//   }
// }
