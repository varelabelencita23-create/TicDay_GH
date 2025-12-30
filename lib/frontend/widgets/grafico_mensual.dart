import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoMensual extends StatefulWidget {
  final List<double> datos; // 0.0 a 1.0

  const GraficoMensual({super.key, required this.datos});

  @override
  State<GraficoMensual> createState() => _GraficoMensualState();
}

class _GraficoMensualState extends State<GraficoMensual> {
  final ScrollController _scrollController = ScrollController();
  final double anchoPorDia = 55;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hoy = DateTime.now().day - 1;
      _scrollController.jumpTo(
        (hoy * anchoPorDia).clamp(
          0,
          _scrollController.position.maxScrollExtent,
        ),
      );
    });
  }

  void _mover(int direccion) {
    _scrollController.animateTo(
      _scrollController.offset + (direccion * anchoPorDia),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final anchoGrafico = widget.datos.length * anchoPorDia;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // ---------------- FLECHAS ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: Colors.pinkAccent,
                onPressed: () => _mover(-1),
              ),
              const Text(
                "Progreso diario",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: Colors.pinkAccent,
                onPressed: () => _mover(1),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ---------------- GRAFICO ----------------
          SizedBox(
            height: 300,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: anchoGrafico,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 130,

                    lineTouchData: LineTouchData(
                      handleBuiltInTouches: true,
                      touchSpotThreshold: 30,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.black87,
                        getTooltipItems: (spots) {
                          return spots.map((spot) {
                            return LineTooltipItem(
                              "Día ${spot.x.toInt() + 1}\n${spot.y.toInt()}%",
                              const TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),

                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: Colors.white10, strokeWidth: 1),
                    ),

                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 25,
                          reservedSize: 36,
                          getTitlesWidget: (value, _) => Text(
                            "${value.toInt()}%",
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, _) => Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "${value.toInt() + 1}",
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),

                    borderData: FlBorderData(show: false),

                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          widget.datos.length,
                          (i) => FlSpot(i.toDouble(), widget.datos[i] * 100),
                        ),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        barWidth: 4.2,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF2E63),
                            Color(0xFFFF6FB1),
                            Color(0xFFFFA6D8),
                          ],
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (_, __, ___, ____) {
                            return FlDotCirclePainter(
                              radius: 6.5,
                              color: Colors.pinkAccent.withOpacity(0.85),
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFFF6FB1).withOpacity(0.35),
                              const Color(0x00FF6FB1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
