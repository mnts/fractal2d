import 'package:fractal/fractal.dart';

import '../policy/base/policy_set.dart';

class DiagramEditorContext extends Fractal {
  //late final CanvasModel canvasModel = CanvasModel(policySet);
  //final CanvasState canvasState = CanvasState();

  final PolicySet policy;
  DiagramEditorContext({
    required this.policy,
  }) : super() {
    //policySet.model = canvasModel;
    //policySet.state = canvasState;
    //policySet.initializePolicy(_getReader(), _getWriter());
  }

  /*
  /// Allows you to create [DiagramEditorContext] with shared model from another [DiagramEditorContext].
  ///
  /// Warning: [LinkAttachmentPolicy] is used in CanvasModel, so this policy will be shared as well, even if you put new one to [PolicySet].
  DiagramEditorContext.withSharedModel(
    DiagramEditorContext oldContext, {
    required this.policySet,
  })  : this._canvasModel = oldContext.canvasModel,
        this._canvasState = CanvasState() {
    policySet.initializePolicy(_getReader(), _getWriter());
  }

  /// Allows you to create [DiagramEditorContext] with shared state (eg. canvas position and scale) from another [DiagramEditorContext].
  DiagramEditorContext.withSharedState(
    DiagramEditorContext oldContext, {
    required this.policySet,
  })  : this._canvasModel = CanvasModel(policySet),
        this._canvasState = oldContext.canvasState {
    policySet.initializePolicy(_getReader(), _getWriter());
  }

  /// Allows you to create [DiagramEditorContext] with shared model and state from another [DiagramEditorContext].
  ///
  /// Warning: [LinkAttachmentPolicy] is used in CanvasModel, so this policy will be shared as well, even if you put new one to [PolicySet].
  DiagramEditorContext.withSharedModelAndState(
    DiagramEditorContext oldContext, {
    required this.policySet,
  })  : this._canvasModel = oldContext.canvasModel,
        this._canvasState = oldContext.canvasState {
    policySet.initializePolicy(_getReader(), _getWriter());
  }

  CanvasReader _getReader() {
    return CanvasReader(CanvasModelReader(canvasModel, canvasState),
        CanvasStateReader(canvasState));
  }

  CanvasWriter _getWriter() {
    return CanvasWriter(CanvasModelWriter(canvasModel, canvasState),
        CanvasStateWriter(canvasState));
  }
  */
}
