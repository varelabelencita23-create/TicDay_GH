import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticday/frontend/temas/temas.dart';

class CalendarioHorizontal extends StatefulWidget {
  final DateTime mesActual;
  final DateTime fechaSeleccionada;
  final ValueChanged<DateTime> onSeleccionar;

  const CalendarioHorizontal({
    super.key,
    required this.mesActual,
    required this.fechaSeleccionada,
    required this.onSeleccionar,
  });

  @override
  State<CalendarioHorizontal> createState() => _CalendarioHorizontalState();
}

class _CalendarioHorizontalState extends State<CalendarioHorizontal> {
  late final ScrollController _scrollController;

  static const double _minItemWidth = 56;
  static const double _itemHeight = 84;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollAlDiaSeleccionado();
    });
  }

  void _scrollAlDiaSeleccionado() {
    final index = widget.fechaSeleccionada.day - 1;
    final estimatedWidth = _minItemWidth + 12;
    final offset = index * estimatedWidth;

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      );
    }
  }

  @override
  void didUpdateWidget(covariant CalendarioHorizontal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!DateUtils.isSameDay(
      oldWidget.fechaSeleccionada,
      widget.fechaSeleccionada,
    )) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollAlDiaSeleccionado();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accentColor = isDark
        ? Temas.AcentoColorOscuro
        : Temas.AcentoColorClaro;

    final diasEnMes = DateTime(
      widget.mesActual.year,
      widget.mesActual.month + 1,
      0,
    ).day;

    final dias = List.generate(
      diasEnMes,
      (i) => DateTime(widget.mesActual.year, widget.mesActual.month, i + 1),
    );

    return SizedBox(
      height: _itemHeight,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dias.length,
        itemBuilder: (_, i) {
          final d = dias[i];
          final seleccionado = DateUtils.isSameDay(d, widget.fechaSeleccionada);
          final esHoy = DateUtils.isSameDay(d, DateTime.now());

          return GestureDetector(
            onTap: () => widget.onSeleccionar(d),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: _minItemWidth),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: seleccionado ? accentColor : theme.cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: seleccionado
                        ? null
                        : Border.all(
                            color: theme.dividerColor.withOpacity(0.15),
                          ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// DIA SEMANA
                      FittedBox(
                        child: Text(
                          DateFormat.E('es').format(d).toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: seleccionado
                                ? Colors.white
                                : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// NUMERO DIA
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: seleccionado
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FittedBox(
                          child: Text(
                            d.day.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: seleccionado
                                  ? accentColor
                                  : theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ),

                      /// HOY
                      if (esHoy && !seleccionado) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
