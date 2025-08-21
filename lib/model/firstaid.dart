class FirstAid {
  final String id;
  final String title;
  final List<FirstAidStep> steps;

  FirstAid({required this.id, required this.title, required this.steps});
}

class FirstAidStep {
  final String imagePath; // e.g. assets/images/brulure_1.png
  final String description;

  FirstAidStep({required this.imagePath, required this.description});
}

final List<FirstAid> firstAidList = [
  FirstAid(
    id: "1",
    title: "Choking",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/1.png",
        description:
            "Lean the person forward and give 5 back blows between the shoulder blades.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/1-1.png",
        description: "Perform 5 abdominal thrusts (Heimlich maneuver).",
      ),
    ],
  ),
  FirstAid(
    id: "2",
    title: "Burns",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/2.png",
        description:
            "Cool the burn under running water for at least 15 minutes.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/2-2.png",
        description: "Cover with a clean, non-stick dressing.",
      ),
    ],
  ),
  FirstAid(
    id: "3",
    title: "Fracture",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/3.png",
        description: "Immobilize the injured area using a splint or sling.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/3-3.png",
        description: "Apply ice to reduce swelling. Seek medical attention.",
      ),
    ],
  ),
  FirstAid(
    id: "4",
    title: "Nosebleed",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/4.png",
        description: "Tilt the head forward and pinch the nose for 10 minutes.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/4-4.png",
        description:
            "Apply a cold compress on the nose and avoid blowing the nose.",
      ),
    ],
  ),
  FirstAid(
    id: "5",
    title: "Seizure",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/5.png",
        description:
            "Protect the person from injury. Do not restrain or put anything in the mouth.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/5-5.png",
        description:
            "Place them in recovery position after the seizure ends and seek help.",
      ),
    ],
  ),
  FirstAid(
    id: "6",
    title: "Heart Attack",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/6.png",
        description: "Call emergency services immediately.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/6-1.png",
        description:
            "Keep the person calm and seated. Give aspirin if advised.",
      ),
    ],
  ),
  FirstAid(
    id: "7",
    title: "Stroke",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/7.png",
        description:
            "Use the FAST method: Face, Arms, Speech, Time to call emergency help.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/7-7.png",
        description: "Keep the person comfortable and monitor vital signs.",
      ),
    ],
  ),
  FirstAid(
    id: "8",
    title: "Fainting",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/8.png",
        description: "Lay the person flat and elevate their legs.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/8-8.png",
        description: "Loosen any tight clothing and ensure fresh air.",
      ),
    ],
  ),
  FirstAid(
    id: "9",
    title: "Bleeding",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/9.png",
        description: "Apply direct pressure on the wound using a clean cloth.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/9-9.png",
        description:
            "Keep the injured part elevated and call for medical help.",
      ),
    ],
  ),
  FirstAid(
    id: "10",
    title: "Poisoning",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/10.png",
        description: "Check for responsiveness and call poison control.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/10-10.png",
        description: "Do not induce vomiting unless told to do so.",
      ),
    ],
  ),
  FirstAid(
    id: "11",
    title: "Electric Shock",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/11.png",
        description: "Turn off the power source before touching the person.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/11-11.png",
        description: "Check breathing and pulse, and call emergency services.",
      ),
    ],
  ),
  FirstAid(
    id: "12",
    title: "Asthma Attack",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/12.png",
        description: "Help the person sit upright and use their inhaler.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/12-12.png",
        description: "Call for medical help if breathing does not improve.",
      ),
    ],
  ),
  FirstAid(
    id: "13",
    title: "Allergic Reaction",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/13.png",
        description: "Check for swelling or breathing difficulty.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/13-13.png",
        description:
            "Use an epinephrine auto-injector if available. Call emergency services.",
      ),
    ],
  ),
  FirstAid(
    id: "14",
    title: "Hypoglycemia (Low Blood Sugar)",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/14.png",
        description: "Give sugary food or drink like juice or glucose tablets.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/14-14.png",
        description: "Monitor response and call help if unconscious.",
      ),
    ],
  ),
  FirstAid(
    id: "15",
    title: "Hyperthermia (Heat Stroke)",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/15.png",
        description:
            "Move the person to a cool area and remove excess clothing.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/15-15.png",
        description: "Cool with wet cloths or fan and call emergency help.",
      ),
    ],
  ),
  FirstAid(
    id: "16",
    title: "Hypothermia",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/16.png",
        description: "Move to a warm place and wrap in blankets.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/16-16.png",
        description: "Do not apply direct heat. Give warm drinks if conscious.",
      ),
    ],
  ),
  FirstAid(
    id: "17",
    title: "Head Injury",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/17.png",
        description: "Keep the person still. Apply cold compress if needed.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/17-17.png",
        description: "Seek emergency help if unconscious or vomiting.",
      ),
    ],
  ),
  FirstAid(
    id: "18",
    title: "Eye Injury",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/18.png",
        description: "Avoid rubbing the eye. Rinse gently with clean water.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/18-18.png",
        description: "Cover with a clean cloth and seek immediate help.",
      ),
    ],
  ),
  FirstAid(
    id: "19",
    title: "Insect Bite",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/19.png",
        description:
            "Clean the area and apply a cold compress to reduce swelling.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/19-19.png",
        description:
            "Watch for allergic reaction and give antihistamines if necessary.",
      ),
    ],
  ),
  FirstAid(
    id: "20",
    title: "Sprain",
    steps: [
      FirstAidStep(
        imagePath: "assets/firstaid/20.png",
        description: "Rest the injured area and apply ice for 20 minutes.",
      ),
      FirstAidStep(
        imagePath: "assets/firstaid/20-20.png",
        description: "Compress with a bandage and elevate the limb.",
      ),
    ],
  ),
];
