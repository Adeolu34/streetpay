import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:flutter/foundation.dart';
import 'form_field_controller.dart';
import 'flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class FlutterFlowDropDown<T> extends StatefulWidget {
  const FlutterFlowDropDown({
    super.key,
    this.controller,
    this.multiSelectController,
    this.hintText,
    this.searchHintText,
    required this.options,
    this.optionLabels,
    this.onChanged,
    this.onMultiSelectChanged,
    this.icon,
    this.width,
    this.height,
    this.maxHeight,
    this.fillColor,
    this.dropdownColor,
    this.searchHintTextStyle,
    this.searchTextStyle,
    this.searchCursorColor,
    required this.textStyle,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderColor,
    this.focusBorderColor,
    required this.margin,
    this.hidesUnderline = false,
    this.disabled = false,
    this.isOverButton = false,
    this.menuOffset,
    this.isSearchable = false,
    this.isMultiSelect = false,
    this.labelText,
    this.labelTextStyle,
    this.optionsHasValueKeys = false,
    this.optionBuilder,
    this.selectedOptionBuilder,
  }) : assert(
          isMultiSelect
              ? (controller == null &&
                  onChanged == null &&
                  multiSelectController != null &&
                  onMultiSelectChanged != null)
              : (controller != null &&
                  onChanged != null &&
                  multiSelectController == null &&
                  onMultiSelectChanged == null),
        );

  final FormFieldController<T?>? controller;
  final FormFieldController<List<T>?>? multiSelectController;
  final String? hintText;
  final String? searchHintText;
  final List<T> options;
  final List<String>? optionLabels;
  final Function(T?)? onChanged;
  final Widget Function(BuildContext context, T option)? optionBuilder;
  final Widget Function(BuildContext context, T option)? selectedOptionBuilder;
  final Function(List<T>?)? onMultiSelectChanged;
  final Widget? icon;
  final double? width;
  final double? height;
  final double? maxHeight;
  final Color? fillColor;
  final Color? dropdownColor;
  final TextStyle? searchHintTextStyle;
  final TextStyle? searchTextStyle;
  final Color? searchCursorColor;
  final TextStyle textStyle;
  final double elevation;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final Color? focusBorderColor;
  final EdgeInsetsGeometry margin;
  final bool hidesUnderline;
  final bool disabled;
  final bool isOverButton;
  final Offset? menuOffset;
  final bool isSearchable;
  final bool isMultiSelect;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final bool optionsHasValueKeys;

  @override
  State<FlutterFlowDropDown<T>> createState() => _FlutterFlowDropDownState<T>();
}

class _FlutterFlowDropDownState<T> extends State<FlutterFlowDropDown<T>> {
  bool get isMultiSelect => widget.isMultiSelect;
  FormFieldController<T?> get controller => widget.controller!;
  FormFieldController<List<T>?> get multiSelectController =>
      widget.multiSelectController!;

  T? get currentValue {
    final value = isMultiSelect
        ? multiSelectController.value?.firstOrNull
        : controller.value;
    return widget.options.contains(value) ? value : null;
  }

  Set<T> get currentValues {
    if (!isMultiSelect || multiSelectController.value == null) {
      return {};
    }
    return widget.options
        .toSet()
        .intersection(multiSelectController.value!.toSet());
  }

  Map<T, String> get optionLabels => Map.fromEntries(
        widget.options.asMap().entries.map(
              (option) => MapEntry(
                option.value,
                widget.optionLabels == null ||
                        widget.optionLabels!.length < option.key + 1
                    ? option.value.toString()
                    : widget.optionLabels![option.key],
              ),
            ),
      );

  Color _getMenuColor(BuildContext context) {
    if (widget.dropdownColor != null &&
        widget.dropdownColor != Colors.transparent &&
        widget.dropdownColor!.a > 0) {
      return widget.dropdownColor!;
    }
    if (widget.fillColor != null &&
        widget.fillColor != Colors.transparent &&
        widget.fillColor!.a > 0) {
      return widget.fillColor!;
    }
    try {
      return FlutterFlowTheme.of(context).secondaryBackground;
    } catch (_) {
      return Colors.white;
    }
  }

  EdgeInsetsGeometry get horizontalMargin {
    final clamped = widget.margin.clamp(
      EdgeInsetsDirectional.zero,
      const EdgeInsetsDirectional.symmetric(horizontal: double.infinity),
    );
    if (clamped == EdgeInsets.zero || clamped == EdgeInsetsDirectional.zero) {
      return const EdgeInsets.symmetric(horizontal: 14.0);
    }
    return clamped;
  }

  late void Function() _listener;
  final TextEditingController _textEditingController = TextEditingController();
  late final FocusNode _focusNode = FocusNode()
    ..addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    if (isMultiSelect) {
      _listener =
          () => widget.onMultiSelectChanged!(multiSelectController.value);
      multiSelectController.addListener(_listener);
    } else {
      _listener = () => widget.onChanged!(controller.value);
      controller.addListener(_listener);
    }
  }

  @override
  void dispose() {
    if (isMultiSelect) {
      multiSelectController.removeListener(_listener);
    } else {
      controller.removeListener(_listener);
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownWidget = _buildDropdownWidget();
    final effectiveBorderColor = _isFocused && widget.focusBorderColor != null
        ? widget.focusBorderColor!
        : widget.borderColor;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: effectiveBorderColor,
            width: widget.borderWidth,
          ),
          color: widget.fillColor,
        ),
        child: Padding(
          padding: _useDropdown2() ? EdgeInsets.zero : widget.margin,
          child: widget.hidesUnderline
              ? DropdownButtonHideUnderline(child: dropdownWidget)
              : dropdownWidget,
        ),
      ),
    );
  }

  bool _useDropdown2() =>
      widget.isMultiSelect ||
      widget.isSearchable ||
      !widget.isOverButton ||
      widget.maxHeight != null;

  Widget _buildDropdownWidget() =>
      _useDropdown2() ? _buildDropdown() : _buildLegacyDropdown();

  Widget _buildLegacyDropdown() {
    return DropdownButtonFormField<T>(
      initialValue: currentValue,
      hint: _createHintText(),
      items: _createMenuItems(),
      elevation: widget.elevation > 0 ? widget.elevation.toInt() : 8,
      onChanged: widget.disabled ? null : (value) => controller.value = value,
      icon: widget.icon,
      isExpanded: true,
      dropdownColor: _getMenuColor(context),
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: widget.labelText == null || widget.labelText!.isEmpty
            ? null
            : widget.labelText,
        labelStyle: widget.labelTextStyle,
        border: widget.hidesUnderline
            ? InputBorder.none
            : const UnderlineInputBorder(),
      ),
    );
  }

  Text? _createHintText() => widget.hintText != null
      ? Text(widget.hintText!, style: widget.textStyle)
      : null;

  ValueKey _getItemKey(T option) {
    final widgetKey = (widget.key as ValueKey).value;
    return ValueKey('$widgetKey ${widget.options.indexOf(option)}');
  }

  List<DropdownMenuItem<T>> _createMenuItems() => widget.options
      .map(
        (option) => DropdownMenuItem<T>(
            key: widget.optionsHasValueKeys ? _getItemKey(option) : null,
            value: option,
            child: Builder(builder: (itemContext) {
              final child = Padding(
                padding: _useDropdown2() ? horizontalMargin : EdgeInsets.zero,
                child: widget.optionBuilder != null
                    ? widget.optionBuilder!(itemContext, option)
                    : Text(optionLabels[option] ?? '', style: widget.textStyle),
              );
              if (kIsWeb) {
                return WebViewAware(child: child);
              }
              return child;
            })),
      )
      .toList();

  List<DropdownMenuItem<T>> _createMultiselectMenuItems() => widget.options
      .map(
        (item) => DropdownMenuItem<T>(
          key: widget.optionsHasValueKeys ? _getItemKey(item) : null,
          value: item,
          // Disable default onTap to avoid closing menu when selecting an item
          enabled: false,
          child: StatefulBuilder(
            builder: (context, menuSetState) {
              final isSelected =
                  multiSelectController.value?.contains(item) ?? false;
              return InkWell(onTap: () {
                multiSelectController.value ??= [];
                isSelected
                    ? multiSelectController.value!.remove(item)
                    : multiSelectController.value!.add(item);
                multiSelectController.update();
                // This rebuilds the StatefulWidget to update the button's text.
                setState(() {});
                // This rebuilds the dropdownMenu Widget to update the check mark.
                menuSetState(() {});
              }, child: Builder(builder: (_) {
                final child = Container(
                  height: double.infinity,
                  padding: horizontalMargin,
                  child: Row(
                    children: [
                      if (isSelected)
                        const Icon(Icons.check_box_outlined)
                      else
                        const Icon(Icons.check_box_outline_blank),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          optionLabels[item]!,
                          style: widget.textStyle,
                        ),
                      ),
                    ],
                  ),
                );
                if (kIsWeb) {
                  return WebViewAware(child: child);
                }
                return child;
              }));
            },
          ),
        ),
      )
      .toList();

  Widget _buildDropdown() {
    final overlayColor = WidgetStateProperty.resolveWith<Color?>((states) =>
        states.contains(WidgetState.focused) ? Colors.transparent : null);
    final menuItemOverlayColor = kIsWeb ? null : overlayColor;
    final iconStyleData = widget.icon != null
        ? IconStyleData(icon: widget.icon!)
        : const IconStyleData();
    return DropdownButton2<T>(
      value: currentValue,
      hint: _createHintText(),
      items: isMultiSelect ? _createMultiselectMenuItems() : _createMenuItems(),
      focusNode: _focusNode,
      iconStyleData: iconStyleData,
      buttonStyleData: ButtonStyleData(
        elevation: widget.elevation.toInt(),
        overlayColor: overlayColor,
        padding: widget.margin,
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.zero,
        overlayColor: menuItemOverlayColor,
      ),
      dropdownStyleData: DropdownStyleData(
        elevation: widget.elevation > 0 ? widget.elevation.toInt() : 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: _getMenuColor(context),
          border: Border.all(
            color: const Color(0xFFE6EAE7),
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x28000000),
              blurRadius: 18.0,
              spreadRadius: 1.0,
              offset: Offset(0, 8),
            ),
          ],
        ),
        isOverButton: widget.isOverButton,
        offset: widget.menuOffset ?? const Offset(0, -4),
        maxHeight: widget.maxHeight ?? 340.0,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
      ),
      onChanged: widget.disabled
          ? null
          : (isMultiSelect ? (_) {} : (val) => widget.controller!.value = val),
      isExpanded: true,
      selectedItemBuilder: (context) => widget.options
          .map(
            (item) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: Builder(builder: (itemContext) {
                  final child = widget.selectedOptionBuilder != null
                      ? widget.selectedOptionBuilder!(itemContext, item)
                      : Text(
                          isMultiSelect
                              ? currentValues
                                  .where((v) => optionLabels.containsKey(v))
                                  .map((v) => optionLabels[v])
                                  .join(', ')
                              : optionLabels[item]!,
                          style: widget.textStyle,
                          maxLines: 1,
                        );
                  if (kIsWeb) {
                    return WebViewAware(child: child);
                  }
                  return child;
                })),
          )
          .toList(),
      dropdownSearchData: widget.isSearchable
          ? DropdownSearchData<T>(
              searchController: _textEditingController,
              searchInnerWidgetHeight: 52,
              searchInnerWidget: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getMenuColor(context),
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFFEEF2EF),
                      width: 1.0,
                    ),
                  ),
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: _textEditingController,
                  cursorColor: widget.searchCursorColor ?? const Color(0xFF2F8F3C),
                  style: widget.searchTextStyle ??
                      const TextStyle(
                        color: Color(0xFF101614),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF3F6F3),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Color(0xFF6E7A72),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: widget.searchHintText ?? 'Search...',
                    hintStyle: widget.searchHintTextStyle ??
                        const TextStyle(
                          color: Color(0xFFA0ABA3),
                          fontSize: 13,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFE6EAE7),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF2F8F3C),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return (optionLabels[item.value] ?? '')
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            )
          : null,
      // This is to clear the search value when you close the menu
      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          if (widget.isSearchable) {
            _textEditingController.clear();
          }
          _focusNode.requestFocus();
        }
      },
    );
  }
}
