import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class DeliveryProcesses extends StatelessWidget {
  const DeliveryProcesses({Key? key, required this.processes})
      : super(key: key);

  final List<String> processes;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: const Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: const Color(0xff989898),
            indicatorTheme: const IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: const ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index],
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 14.0,
                          ),
                    ),
                    //InnerTimeline(messages: processes),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (index > 2) {
                return const DotIndicator(
                  size: 15,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              } else {
                return const DotIndicator(
                  size: 15,
                  color: Color(0xff66c97f),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              }
            },
            connectorBuilder: (_, index, ___) => SizedBox(
                height: 44.0,
                child: SolidLineConnector(
                  color: index > 2 ? null : const Color(0xff66c97f),
                )),
          ),
        ),
      ),
    );
  }
}
