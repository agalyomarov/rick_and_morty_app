import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/core/constants/app_colors.dart';
import 'package:rick_and_morty_app/models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  const new({required this.character, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(color: AppColors.cellBg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: CachedNetworkImage(
              imageUrl: character.image,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        character.name,
                        style: TextStyle(color: AppColors.bodyText, fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 4,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: character.status == "Alive" ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            width: 6,
                            height: 6,
                          ),
                          Text(character.status, style: TextStyle(fontSize: 10, color: Colors.white)),
                          Text("-", style: TextStyle(fontSize: 10, color: Colors.white)),
                          Text(character.species, style: TextStyle(fontSize: 10, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Last known location:",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 9),
                      ),
                      Text(
                        character.location.name,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Origin:",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 9),
                      ),
                      Text(
                        character.origin.name,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
