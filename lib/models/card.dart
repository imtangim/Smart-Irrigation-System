import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NpkCard extends StatefulWidget {
  final String cardname;
  final double cardvalue;

  const NpkCard({
    super.key,
    required this.cardname,
    required this.cardvalue,
  });

  @override
  State<NpkCard> createState() => _NpkCardState();
}

class _NpkCardState extends State<NpkCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 50,
            lineWidth: 10,
            percent: widget.cardname == "Mosture"
                ? widget.cardvalue / 100
                : double.parse(
                    ((0.3921 * widget.cardvalue) / 100).toStringAsFixed(1)),
            progressColor: Colors.deepPurple,
            backgroundColor: Colors.deepPurple.shade100,
            circularStrokeCap: CircularStrokeCap.round,
            startAngle: 180,
            center: Text(
              widget.cardname == "Mosture"
                  ? '${widget.cardvalue} %'
                  : (widget.cardvalue).toString(),
              style: const TextStyle(
                fontFamily: "Lato",
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.deepPurple,
              ),
            ),
            animation: true,
          ),
          const SizedBox(height: 10),
          Text(
            widget.cardname,
            style: TextStyle(
              fontFamily: "Lato",
              fontSize: widget.cardname == "Mosture" ? 18 : 20,
              fontWeight: FontWeight.w900,
              color: Colors.deepPurple,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
