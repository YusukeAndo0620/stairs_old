// import 'package:stairs/loom/loom_package.dart';
// import 'package:collection/collection.dart';
// import 'package:equatable/equatable.dart';

// import '../../model/model.dart';
// import '../../model/dummy.dart';

// const kShrinkId = 'shrinkId';

// // Event
// abstract class WorkBoardListBlocEvent {
//   const WorkBoardListBlocEvent();
// }

// class _Init extends WorkBoardListBlocEvent {
//   const _Init();
// }

// class WorkBoardListGetList extends WorkBoardListBlocEvent {
//   const WorkBoardListGetList({required this.workBoardId});
//   final String workBoardId;
// }

// class WorkBoardListAddCard extends WorkBoardListBlocEvent {
//   const WorkBoardListAddCard({required this.workBoardId});

//   final String workBoardId;
// }

// class WorkBoardListAddTaskItem extends WorkBoardListBlocEvent {
//   const WorkBoardListAddTaskItem({
//     required this.workBoardId,
//     required this.inputValue,
//     required this.dueDate,
//     required this.labelList,
//   });

//   final String workBoardId;
//   final String inputValue;
//   final DateTime dueDate;
//   final List<ColorLabelInfo> labelList;
// }

// class WorkBoardListTapListItem extends WorkBoardListBlocEvent {
//   const WorkBoardListTapListItem({required this.workBoardItemId});

//   final String workBoardItemId;
// }

// class WorkBoardListTapEdit extends WorkBoardListBlocEvent {
//   const WorkBoardListTapEdit({
//     required this.workBoardItemId,
//     required this.context,
//     required this.theme,
//   });

//   final String workBoardItemId;
//   final BuildContext context;
//   final LoomThemeData theme;
// }

// class WorkBoardListDeleteListItem extends WorkBoardListBlocEvent {
//   const WorkBoardListDeleteListItem({
//     required this.workBoardItemId,
//   });
//   final String workBoardItemId;
// }

// class WorkBoardListDeleteShrinkItem extends WorkBoardListBlocEvent {
//   const WorkBoardListDeleteShrinkItem();
// }

// /// Replace dragging item to shrink item.
// class WorkBoardListReplaceShrinkItem extends WorkBoardListBlocEvent {
//   const WorkBoardListReplaceShrinkItem({
//     required this.workBoardItemId,
//   });
//   final String workBoardItemId;
// }

// // Delete and Add shrink item when item is dragging.
// class WorkBoardListDeleteAndAddShrinkItem extends WorkBoardListBlocEvent {
//   const WorkBoardListDeleteAndAddShrinkItem({
//     required this.workBoardId,
//     required this.insertingIndex,
//   });

//   final String workBoardId;
//   final int insertingIndex;
// }

// // Complete dragging.
// class WorkBoardListCompleteDraggedItem extends WorkBoardListBlocEvent {
//   const WorkBoardListCompleteDraggedItem({
//     required this.draggingItem,
//   });
//   final TaskItemInfo draggingItem;
// }

// // State
// @immutable
// class WorkBoardListBlocState extends Equatable {
//   WorkBoardListBlocState({
//     required this.workBoardId,
//     required this.taskItemList,
//   });

//   final String workBoardId;
//   final List<TaskItemInfo> taskItemList;
//   final ScrollController scrollController = ScrollController();

//   @override
//   List<Object?> get props => [
//         workBoardId,
//         taskItemList,
//         scrollController,
//       ];

//   WorkBoardListBlocState copyWith({
//     String? workBoardId,
//     List<TaskItemInfo>? taskItemList,
//   }) =>
//       WorkBoardListBlocState(
//         workBoardId: workBoardId ?? this.workBoardId,
//         taskItemList: taskItemList ?? this.taskItemList,
//       );

//   ///Check shrink item is included in target work board card list.
//   bool get hasShrinkItem =>
//       taskItemList.firstWhereOrNull(
//         (element) => element.workBoardItemId == kShrinkId,
//       ) !=
//       null;
// }

// // Bloc
// class WorkBoardListBloc
//     extends Bloc<WorkBoardListBlocEvent, WorkBoardListBlocState> {
//   WorkBoardListBloc()
//       : super(
//           WorkBoardListBlocState(workBoardId: '', taskItemList: []),
//         ) {
//     on<_Init>(_onInit);
//     on<WorkBoardListGetList>(_onGetList);
//     on<WorkBoardListTapListItem>(_onTapListItem);
//     on<WorkBoardListAddCard>(_onAddCard);
//     on<WorkBoardListAddTaskItem>(_onAddTaskItem);
//     on<WorkBoardListTapEdit>(_onTapEdit);
//     on<WorkBoardListDeleteListItem>(_onDeleteListItem);
//     on<WorkBoardListDeleteShrinkItem>(_onDeleteShrinkItem);
//     on<WorkBoardListReplaceShrinkItem>(_onReplaceShrinkItem);
//     on<WorkBoardListDeleteAndAddShrinkItem>(_onDeleteAndAddShrinkItem);
//     on<WorkBoardListCompleteDraggedItem>(_onReplaceDraggedItem);
//   }

//   void _onInit(_Init event, Emitter<WorkBoardListBlocState> emit) {
//     emit(WorkBoardListBlocState(workBoardId: '', taskItemList: const []));
//   }

//   Future<void> _onGetList(
//       WorkBoardListGetList event, Emitter<WorkBoardListBlocState> emit) async {
//     final dummyWorkBoardItemList = dummyWorkBoardList
//         .firstWhere((element) => element.workBoardId == event.workBoardId)
//         .taskItemList;

//     emit(state.copyWith(taskItemList: dummyWorkBoardItemList));
//   }

//   Future<void> _onTapListItem(WorkBoardListTapListItem event,
//       Emitter<WorkBoardListBlocState> emit) async {}

//   Future<void> _onAddCard(
//       WorkBoardListAddCard event, Emitter<WorkBoardListBlocState> emit) async {}

//   Future<void> _onAddTaskItem(WorkBoardListAddTaskItem event,
//       Emitter<WorkBoardListBlocState> emit) async {
//     final emitWorkBoardItemList = [...state.taskItemList];

//     emitWorkBoardItemList.add(
//       TaskItemInfo(
//         workBoardId: event.workBoardId,
//         workBoardItemId: uuid.v4(),
//         title: event.inputValue,
//         description: '',
//         startDate: DateTime.now(),
//         endDate: event.dueDate,
//         labelList: event.labelList,
//       ),
//     );
//     emit(
//       state.copyWith(taskItemList: emitWorkBoardItemList),
//     );
//   }

//   void _onTapEdit(
//       WorkBoardListTapEdit event, Emitter<WorkBoardListBlocState> emit) {
//     // showModalBottomSheet(
//     //   context: event.context,
//     //   isScrollControlled: true,
//     //   backgroundColor: Colors.transparent,
//     //   builder: (context) {
//     //     return BoardModal(boardId: event.boardId);
//     //   },
//     // );
//   }

//   Future<void> _onDeleteListItem(WorkBoardListDeleteListItem event,
//       Emitter<WorkBoardListBlocState> emit) async {
//     final targetList = [...state.taskItemList];

//     final deleteWorkBoardListItemIndex = targetList.indexWhere(
//       (element) => element.workBoardItemId == event.workBoardItemId,
//     );
//     targetList.removeAt(deleteWorkBoardListItemIndex);
//     emit(state.copyWith(taskItemList: targetList));
//   }

//   Future<void> _onDeleteShrinkItem(WorkBoardListDeleteShrinkItem event,
//       Emitter<WorkBoardListBlocState> emit) async {
//     final targetList = [...state.taskItemList];
//     if (!state.hasShrinkItem) return;

//     final deleteWorkBoardItemIndex = targetList.indexWhere(
//       (element) => element.workBoardItemId == kShrinkId,
//     );
//     if (deleteWorkBoardItemIndex == -1) {
//       return;
//     }
//     targetList.removeAt(deleteWorkBoardItemIndex);
//     emit(state.copyWith(taskItemList: targetList));
//   }

//   Future<void> _onReplaceShrinkItem(WorkBoardListReplaceShrinkItem event,
//       Emitter<WorkBoardListBlocState> emit) async {
//     final shrinkItem = getShrinkItem(workBoardId: state.workBoardId);
//     final targetList = [...state.taskItemList];
//     final workBoardListItemIndex = targetList.indexWhere(
//       (element) => element.workBoardItemId == event.workBoardItemId,
//     );
//     targetList[workBoardListItemIndex] = shrinkItem;

//     emit(state.copyWith(taskItemList: targetList));
//   }

//   Future<void> _onDeleteAndAddShrinkItem(
//       WorkBoardListDeleteAndAddShrinkItem event,
//       Emitter<WorkBoardListBlocState> emit) async {
//     final shrinkItem = getShrinkItem(workBoardId: event.workBoardId);
//     final targetList = [...state.taskItemList];

//     if (!state.hasShrinkItem) return;
//     final currentShrinkItemWBItemIndex = targetList
//         .indexWhere((element) => element.workBoardItemId == kShrinkId);
//     targetList.insert(event.insertingIndex, shrinkItem);
//     targetList.removeAt(currentShrinkItemWBItemIndex < event.insertingIndex
//         ? currentShrinkItemWBItemIndex
//         : currentShrinkItemWBItemIndex + 1);

//     emit(state.copyWith(taskItemList: targetList));
//   }

//   Future<void> _onReplaceDraggedItem(WorkBoardListCompleteDraggedItem event,
//       Emitter<WorkBoardListBlocState> emit) async {
//     final targetList = [...state.taskItemList];
//     final workBoardListItemIndex = targetList.indexWhere(
//       (element) => element.workBoardItemId == kShrinkId,
//     );
//     if (workBoardListItemIndex < 0) return;
//     targetList[workBoardListItemIndex] = event.draggingItem;
//     emit(state.copyWith(taskItemList: targetList));
//   }

//   /// shrink itemを生成。取得。
//   TaskItemInfo getShrinkItem({required String workBoardId}) {
//     return TaskItemInfo(
//       workBoardId: workBoardId,
//       workBoardItemId: kShrinkId,
//       title: '',
//       description: '',
//       startDate: DateTime.now(),
//       endDate: DateTime.now(),
//       labelList: [],
//     );
//   }
// }
