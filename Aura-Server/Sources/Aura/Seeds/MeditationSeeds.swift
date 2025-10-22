//
//  MeditationSeeds.swift
//  Aura
//
//  Created by Chabane on 16/10/2025.
//

import Vapor
import Fluent


struct MeditationSeeds: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await Meditation.query(on: db).delete()

        try await [
          // JAUNE
            Meditation(
                theme: "Coup de Coeur",
                audio: "audio-medi1.mp3",
                title: "Le calme interieur",
                duration: 2,
                image: "jaune-emote1",
                thumbnail: "jaune-meditation1"
            ),
            Meditation(
                theme: "Coup de Coeur",
                audio: "audio-medi2.mp3",
                title: "Libérer les tensions",
                duration: 4,
                image: "jaune-emote2",
                thumbnail: "jaune-meditation2"
            ),
            Meditation(
                theme: "Coup de Coeur",
                audio: "audio-medi3.mp3",
                title: "Apaiser l’esprit",
                duration: 6,
                image: "jaune-emote3",
                thumbnail: "jaune-meditation3"
            ),
            Meditation(
                theme: "Coup de Coeur",
                audio: "audio-medi4.mp3",
                title: "Se déposer dans le silence",
                duration: 2,
                image: "jaune-emote4",
                thumbnail: "jaune-meditation4"
            ),
            Meditation(
                theme: "Coup de Coeur",
                audio: "audio-medi5.mp3",
                title: "Moment de sérénité",
                duration: 3,
                image: "jaune-emote1",
                thumbnail: "jaune-meditation5"
            ),
            // ORANGE
            Meditation(
                theme: "Débutants",
                audio: "audio-medi1.mp3",
                title: "Ancrage dans l’instant",
                duration: 2,
                image: "orange-emote1",
                thumbnail: "orange-meditation1"
            ),
            Meditation(
                theme: "Débutants",
                audio: "audio-medi2.mp3",
                title: "Observer sans juger",
                duration: 4,
                image: "orange-emote2",
                thumbnail: "orange-meditation2"
            ),
            Meditation(
                theme: "Débutants",
                audio: "audio-medi3.mp3",
                title: "Présence attentive",
                duration: 5,
                image: "Débutants",
                thumbnail: "orange-meditation3"
            ),
            Meditation(
                theme: "Débutants",
                audio: "audio-medi4.mp3",
                title: "Se déposer dans le silence",
                duration: 3,
                image: "orange-emote4",
                thumbnail: "orange-meditation4"
            ),
            Meditation(
                theme: "Débutants",
                audio: "audio-medi5.mp3",
                title: "Clarté mentale",
                duration: 2,
                image: "orange-emote5",
                thumbnail: "orange-meditation5"
            ),
            // VIOLET
            Meditation(
                theme: "Nouveau",
                audio: "audio-medi1.mp3",
                title: "Se déposer dans le silence",
                duration: 2,
                image: "violet-emote1",
                thumbnail: "violet-meditation1"
            ),
            Meditation(
                theme: "Nouveau",
                audio: "audio-medi2.mp3",
                title: "La flamme de l’attention",
                duration: 1,
                image: "violet-emote2",
                thumbnail: "violet-meditation2"
            ),
            Meditation(
                theme: "Nouveau",
                audio: "audio-medi3.mp3",
                title: "Focus intérieur",
                duration: 3,
                image: "violet-emote3",
                thumbnail: "violet-meditation3"
            ),
            Meditation(
                theme: "Nouveau",
                audio: "audio-medi4.mp3",
                title: "Voyage intérieur vers le sommeil",
                duration: 2,
                image: "violet-emote4",
                thumbnail: "violet-meditation4"
            ),
            Meditation(
                theme: "Nouveau",
                audio: "audio-medi5.mp3",
                title: "S’endormir en pleine conscience",
                duration: 8,
                image: "violet-emote5",
                thumbnail: "violet-meditation5"
            ),
            // VERT
            Meditation(
                theme: "Éveil doux",
                audio: "audio-medi1.mp3",
                title: "Détente profonde",
                duration: 2,
                image: "vert-emote1",
                thumbnail: "vert-meditation1"
            ),
            Meditation(
                theme: "Éveil doux",
                audio: "audio-medi2.mp3",
                title: "Nuit paisible",
                duration: 5,
                image: "vert-emote2",
                thumbnail: "vert-meditation2"
            ),
            Meditation(
                theme: "Éveil doux",
                audio: "audio-medi3.mp3",
                title: "Cultiver la gratitude",
                duration: 3,
                image: "vert-emote3",
                thumbnail: "vert-meditation3"
            ),
            Meditation(
                theme: "Éveil doux",
                audio: "audio-medi4.mp3",
                title: "Moments de joie intérieure",
                duration: 1,
                image: "vert-emote4",
                thumbnail: "vert-meditation4"
            ),
            Meditation(
                theme: "Éveil doux",
                audio: "audio-medi5.mp3",
                title: "Paix et harmonie",
                duration: 2,
                image: "vert-emote5",
                thumbnail: "vert-meditation5"
            ),
            // ROSE
            Meditation(
                theme: "Énergie et equilibre",
                audio: "audio-medi1.mp3",
                title: "Marche dans la forêt intérieure",
                duration: 3,
                image: "rose-emote1",
                thumbnail: "rose-meditation1"
            ),
            Meditation(
                theme: "Énergie et equilibre",
                audio: "audio-medi2.mp3",
                title: "Lumière et ombre",
                duration: 2,
                image: "rose-emote2",
                thumbnail: "rose-meditation2"
            ),
            Meditation(
                theme: "Énergie et equilibre",
                audio: "audio-medi3.mp3",
                title: "Flot de la rivière intérieure",
                duration: 1,
                image: "rose-emote3",
                thumbnail: "rose-meditation3"
            ),
            Meditation(
                theme: "Énergie et equilibre",
                audio: "audio-medi4.mp3",
                title: "Éveil des sens intérieurs",
                duration: 3,
                image: "rose-emote4",
                thumbnail: "rose-meditation4"
            ),
            Meditation(
                theme: "Énergie et equilibre",
                audio: "audio-medi5.mp3",
                title: "Harmonie du corps",
                duration: 4,
                image: "rose-emote5",
                thumbnail: "rose-meditation5"
            ),
        ].create(on: db)
    }

    func revert(on db: any Database) async throws {
        try await Meditation.query(on: db).delete()
    }
}
