import 'package:rxdart/rxdart.dart';
import 'package:xhabits/src/presentation/widgets/xh_bottom_bar_bloc.dart';

class BaseScreenBloc {

  final XHBottomBarBloc _xhBottomBarBloc = XHBottomBarBloc(0);

  XHBottomBarBloc get bottomBarBloc => _xhBottomBarBloc;
  Stream<int> get selectedIndexObservable => _xhBottomBarBloc.currentIndexObservable;
}