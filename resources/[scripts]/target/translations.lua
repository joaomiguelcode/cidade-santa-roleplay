lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        -- ATM and Financial Actions
        ["enter_apartment"] = "Enter Apartment",
        ["rob_atm"] = "Rob ATM",
        ["access_atm"] = "Access ATM",

        -- Shops and Food-related Interactions
        ["buy"] = "Buy",
        ["drink"] = "Drink",
        ["fill"] = "Fill",
        ["assemble_combo"] = "Assemble Combo",
        ["assemble_sandwich"] = "Assemble Sandwich",
        ["fill_cup"] = "Fill Cup",
        ["clean_vehicle"] = "Clean Vehicle",
        ["clean_vehicle_2"] = "Clean Vehicle 2",

        -- Call Delivery
        ["call_deliverers"] = "Call Deliverers",
        ["call_burgershot"] = "Call Burger Shot",
        ["call_uwu_coffee"] = "Call UwU Coffee",
        ["call_pizza_this"] = "Call Pizza This",
        ["call_bean_machine"] = "Call Bean Machine",

        -- Interaction with Items/Objects
        ["call_phone"] = "Call",
        ["hide"] = "Hide",
        ["inspect"] = "Inspect",
        ["open"] = "Open",
        ["pick_up"] = "Pick Up",
        ["destroy"] = "Destroy",
        ["open_trunk"] = "Open Trunk",
        ["close_trunk"] = "Close Trunk",
        ["check_trunk"] = "Check Trunk",
        ["check_item"] = "Check Item",

        -- Medical and Emergency Services
        ["apply_plastic_surgery"] = "Apply Plastic Surgery",
        ["revive"] = "Revive",
        ["lay_patient_down"] = "Lay Patient Down",
        ["apply_bandages"] = "Apply Bandages",
        ["extract_blood"] = "Extract Blood",
        ["diagnosis"] = "Diagnosis",
        ["treatment"] = "Treatment",
        ["diagnostic"] = "Diagnostic",
        ["surgical_procedures"] = "Surgical Procedures",

        -- Weapon License Actions
        ["add_weapon_license"] = "Add Weapon License",
        ["remove_weapon_license"] = "Remove Weapon License",
        ["check_weapon_license"] = "Check Weapon License",
        

        -- Vehicle Interactions
        ["remove_tire"] = "Remove Tire",
        ["inspect_vehicle"] = "Inspect Vehicle",
        ["fix_vehicle"] = "Fix Vehicle",
        ["enter_trunk"] = "Enter Trunk",
        ["break_into_trunk"] = "Break into Trunk",
        ["impound_vehicle"] = "Impound Vehicle",
        ["report_vehicle"] = "Report Vehicle",
        ["repair_vehicle"] = "Repair Vehicle",
        ["create_duplicate_key"] = "Create Duplicate Key",
        ["change_plate"] = "Change Plate",
        ["refuel"] = "Refuel",
        ["roll_vehicle"] = "Roll Vehicle",
        ["tow_vehicle"] = "Tow Vehicle",
        ["steal_trunk"] = "Steal Trunk",
        ["remove_tyres"] = "Remove Tyres",
        ["clean_vehicle"] = "Clean Vehicle",
        ["register_vehicle"] = "Impound Vehicle",
        ["call_mechanic"] = "Call Mechanic",

        -- Miscellaneous Actions
        ["steal_shoes"] = "Steal Shoes",
        ["war_mode"] = "War Mode",
        ["check_plate"] = "Check Plate",
        ["remove_from_vehicle"] = "Remove from Vehicle",
        ["impound"] = "Impound",
        ["family"] = "Family",
        ["evaluate_player"] = "Evaluate Player",
        ["fortune_wheel"] = "Fortune Wheel",
        ["seize_items"] = "Seize Items",

        -- Social Media Links
        ["instagram"] = "Instagram",
        ["tiktok"] = "TikTok",

        -- Yoga and Recreational Activities
        ["yoga"] = "Yoga",
        ["make_products"] = "Make Products",
        ["slot_machine"] = "Slot Machine",

        -- Player and NPC Interactions
        ["talk"] = "Talk",
        ["frisk"] = "Frisk",
        ["loot"] = "Loot",
        ["report_box"] = "Report Box",
        ["steal_vehicle"] = "Steal Vehicle",
        ["rate_player"] = "Rate Player",

        -- WallStreet and Economy-related
        ["start_wall_street"] = "Start WallStreet",
        ["bank_operations"] = "Bank Operations",

        -- Fuel and Vehicle Maintenance
        ["fuel_vehicle"] = "Fuel Vehicle",
        ["check_oil"] = "Check Oil",

        -- Relationship Status
        ["relationship"] = "Relationship",
        ["Solteiro"] = "Single",
        ["married"] = "Married",
        ["Namorando"] = "In a Relationship",
        ["engaged"] = "Engaged",
        ["relationships"] = "Relationship",

        -- Custom User Interactions
        ["family_status"] = "Family Status",
        ["member"] = "Member",
        ["leader"] = "Leader",

        ["getup"] = "Get up",
        ["sit"] = "Sit",
        ["sleep"] = "Sleep",
        ["enterCar"] = "Get into car",
        ["follow"] = "Follow",
        ["guard"] = "Guard",
        ["exitCar"] = "Get pet out of car",
        ["changeName"] = "Change pet name",

        ["entityTarget"] = "Auricular interaction.",

        ["beginner"] = "BEGINNER",
        ["rate"] = "Rate",
        ["wanted"] = "WANTED",
        ["lay_down"] = "Lay Down",
        ["treatment"] = "Treatment",
        ["fuel"] = "Refuel",

        -- Vehicle Lock Status
        ["lock_vehicle"] = "Lock [L]",
        ["unlock_vehicle"] = "Unlock [L]",
        ["enter_vehicle"] = "Enter Vehicle [F]",

        -- Treatment Dialog
        ["treatment_request"] = "Proceed with treatment for $%s?",
        ["treatment_accept"] = "Yes, start treatment",
        ["treatment_decline"] = "No, I'll come back later",
        ["dismantle"] = "Dismantle",
        ["noVIP"] = "NO VIP",

        ["under_evaluation"] = "Under Evaluation",

        ["commercial_team"] = "Commercial Team",

        ["call_mechanic_message"] = "The vehicle won't start.",
        ["tow_vehicle"] = "Tow vehicle",
        ["untow_vehicle"] = "Release vehicle",

        ["level_social"] = "SOCIAL %s 💫",
    },

    ["pt-br"] = {
        -- ATM and Financial Actions
        ["enter_apartment"] = "Entrar Apartamento",
        ["rob_atm"] = "Roubar Caixa Eletronico",
        ["access_atm"] = "Acessar Caixa Eletronico",

        -- Shops and Food-related Interactions
        ["buy"] = "Comprar",
        ["drink"] = "Beber",
        ["fill"] = "Encher",
        ["assemble_combo"] = "Montar Combo",
        ["assemble_sandwich"] = "Montar Lanche",
        ["fill_cup"] = "Encher Copo",
        ["clean_vehicle"] = "Limpar Veículo",
        ["clean_vehicle_2"] = "Limpar Veículo 2",

        -- Call Delivery
        ["call_deliverers"] = "Chamar Entregadores",
        ["call_burgershot"] = "Chamar Burger Shot",
        ["call_uwu_coffee"] = "Chamar UwU Coffee",
        ["call_pizza_this"] = "Chamar Pizza This",
        ["call_bean_machine"] = "Chamar Bean Machine",

        -- Interaction with Items/Objects
        ["call_phone"] = "Ligar",
        ["hide"] = "Esconder",
        ["inspect"] = "Verificar",
        ["open"] = "Abrir",
        ["pick_up"] = "Pegar",
        ["destroy"] = "Destruir",
        ["open_trunk"] = "Abrir Porta-Malas",
        ["close_trunk"] = "Fechar Porta-Malas",
        ["check_trunk"] = "Checar Porta-Malas",
        ["check_item"] = "Checar Item",

        -- Medical and Emergency Services
        ["apply_plastic_surgery"] = "Aplicar Plástica",
        ["revive"] = "Reviver",
        ["lay_patient_down"] = "Deitar Paciente",
        ["apply_bandages"] = "Passar Ataduras",
        ["extract_blood"] = "Extrair Sangue",
        ["diagnosis"] = "Informações",
        ["treatment"] = "Tratamento",
        ["diagnostic"] = "Diagnóstico",
        ["surgical_procedures"] = "Procedimentos Cirúrgicos",

        -- Weapon License Actions
        ["add_weapon_license"] = "Adicionar Licença de Armas",
        ["remove_weapon_license"] = "Remover Licença de Armas",
        ["check_weapon_license"] = "Verificar Licença de Armas",

        -- Vehicle Interactions
        ["remove_tire"] = "Retirar Pneu",
        ["inspect_vehicle"] = "Inspecionar Veículo",
        ["fix_vehicle"] = "Fixar Veículo",
        ["enter_trunk"] = "Entrar no Porta-Malas",
        ["break_into_trunk"] = "Arrombar Porta-Malas",
        ["impound_vehicle"] = "Apreender Veículo",
        ["report_vehicle"] = "Reportar Veículo",
        ["repair_vehicle"] = "Reparar Veículo",
        ["create_duplicate_key"] = "Criar Chave Cópia",
        ["change_plate"] = "Trocar Placa",
        ["refuel"] = "Abastecer",
        ["roll_vehicle"] = "Desvirar Veículo",
        ["tow_vehicle"] = "Reboque de Veículo",
        ["steal_trunk"] = "Roubar Porta-Malas",
        ["remove_tyres"] = "Remover Pneus",
        ["call_mechanic"] = "Chamar Mecânico",

        -- Miscellaneous Actions
        ["steal_shoes"] = "Roubar Sapatos",
        ["war_mode"] = "Modo Guerra",
        ["check_plate"] = "Verificar Placa",
        ["remove_from_vehicle"] = "Retirar do Veículo",
        ["register_vehicle"] = "Apreender Veiculo",
        ["impound"] = "Apreender",
        ["family"] = "Família",
        ["evaluate_player"] = "Avaliar Jogador",
        ["fortune_wheel"] = "Roda da Fortuna",
        ["seize_items"] = "Apreender Itens",

        -- Social Media Links
        ["instagram"] = "Instagram",
        ["tiktok"] = "TikTok",

        -- Yoga and Recreational Activities
        ["yoga"] = "Yoga",
        ["make_products"] = "Fazer Produtos",
        ["slot_machine"] = "Caça-Níqueis",

        -- Player and NPC Interactions
        ["talk"] = "Conversar",
        ["frisk"] = "Revistar",
        ["loot"] = "Saque",
        ["report_box"] = "Relatório",
        ["steal_vehicle"] = "Roubar Veículo",
        ["rate_player"] = "Avaliar Jogador",

        -- WallStreet and Economy-related
        ["start_wall_street"] = "Iniciar WallStreet",
        ["bank_operations"] = "Operações Bancárias",

        -- Fuel and Vehicle Maintenance
        ["fuel_vehicle"] = "Abastecer Combustível",
        ["check_oil"] = "Verificar Óleo",

        -- Relationship Status
        ["relationship"] = "Relacionamento",
        ["Solteiro"] = "Solteiro",
        ["married"] = "Casado",
        ["Namorando"] = "Namorando",
        ["engaged"] = "Noivo",
        ["relationships"] = "Relacionar-se",

        -- Custom User Interactions
        ["family_status"] = "Família Status",
        ["member"] = "Membro",
        ["leader"] = "Líder",

        -- Pets
        ["getup"] = "Levantar",
        ["sit"] = "Sentar",
        ["sleep"] = "Dormir",
        ["enterCar"] = "Entrar no carro",
        ["follow"] = "Seguir",
        ["guard"] = "Guardar",
        ["exitCar"] = "Retirar Pet",
        ["changeName"] = "Mudar Nome",
        ["entityTarget"] = "Interação auricular.",

        ["beginner"] = "INICIANTE",
        ["rate"] = "Nota",
        ["wanted"] = "PROCURADO",
        ["lay_down"] = "Deitar",
        ["treatment"] = "Tratamento",
        ["fuel"] = "Abastecer",

        -- Vehicle Lock Status
        ["lock_vehicle"] = "Trancar [L]",
        ["unlock_vehicle"] = "Destrancar [L]",
        ["enter_vehicle"] = "Entrar no Veículo [F]",

        -- Treatment Dialog
        ["treatment_request"] = "Prosseguir o tratamento por $%s dólares?",
        ["treatment_accept"] = "Sim, iniciar tratamento",
        ["treatment_decline"] = "Não, volto mais tarde",
        ["dismantle"] = "Desmanchar",
        ["noVIP"] = "SEM VIP",

        ["under_evaluation"] = "em Avaliação",

        ["commercial_team"] = "Time Comercial",

        ["call_mechanic_message"] = "O veículo não liga.",
        ["tow_vehicle"] = "Guinchar veículo",
        ["untow_vehicle"] = "Soltar veículo",

        ["level_social"] = "SOCIAL %s 💫",
    },

    ["fr-fr"] = {
        -- ATM and Financial Actions
        ["enter_apartment"] = "Entrer dans l'appartement",
        ["rob_atm"] = "Braquer le distributeur",
        ["access_atm"] = "Accéder au distributeur",

        -- Shops and Food-related Interactions
        ["buy"] = "Acheter",
        ["drink"] = "Boire",
        ["fill"] = "Remplir",
        ["assemble_combo"] = "Préparer le combo",
        ["assemble_sandwich"] = "Préparer le sandwich",
        ["fill_cup"] = "Remplir le gobelet",
        ["clean_vehicle"] = "Laver le véhicule",
        ["clean_vehicle_2"] = "Laver le véhicule 2",

        -- Call Delivery
        ["call_deliverers"] = "Appeler les livreurs",
        ["call_burgershot"] = "Appeler Burger Shot",
        ["call_uwu_coffee"] = "Appeler UwU Coffee",
        ["call_pizza_this"] = "Appeler Pizza This",
        ["call_bean_machine"] = "Appeler Bean Machine",

        -- Interaction with Items/Objects
        ["call_phone"] = "Appeler",
        ["hide"] = "Cacher",
        ["inspect"] = "Vérifier",
        ["open"] = "Ouvrir",
        ["pick_up"] = "Ramasser",
        ["destroy"] = "Détruire",
        ["open_trunk"] = "Ouvrir le coffre",
        ["close_trunk"] = "Fermer le coffre",
        ["check_trunk"] = "Vérifier le coffre",
        ["check_item"] = "Vérifier l'objet",

        -- Medical and Emergency Services
        ["apply_plastic_surgery"] = "Appliquer la chirurgie esthétique",
        ["revive"] = "Réanimer",
        ["lay_patient_down"] = "Allonger le patient",
        ["apply_bandages"] = "Pansements",
        ["extract_blood"] = "Prélever du sang",
        ["diagnosis"] = "Informations",
        ["treatment"] = "Traitement",
        ["diagnostic"] = "Diagnostic",
        ["surgical_procedures"] = "Actes chirurgicaux",

        -- Weapon License Actions
        ["add_weapon_license"] = "Ajouter le permis d'armes",
        ["remove_weapon_license"] = "Retirer le permis d'armes",
        ["check_weapon_license"] = "Vérifier le permis d'armes",

        -- Vehicle Interactions
        ["remove_tire"] = "Retirer le pneu",
        ["inspect_vehicle"] = "Inspecter le véhicule",
        ["fix_vehicle"] = "Réparer le véhicule",
        ["enter_trunk"] = "Entrer dans le coffre",
        ["break_into_trunk"] = "Forcer le coffre",
        ["impound_vehicle"] = "Mettre en fourrière",
        ["report_vehicle"] = "Signaler le véhicule",
        ["repair_vehicle"] = "Réparer le véhicule",
        ["create_duplicate_key"] = "Faire un double de clé",
        ["change_plate"] = "Changer la plaque",
        ["refuel"] = "Ravitaillement",
        ["roll_vehicle"] = "Remettre le véhicule sur roues",
        ["tow_vehicle"] = "Dépanner le véhicule",
        ["steal_trunk"] = "Cambrioler le coffre",
        ["remove_tyres"] = "Retirer les pneus",
        ["call_mechanic"] = "Appeler le mécanicien",

        -- Miscellaneous Actions
        ["steal_shoes"] = "Voler les chaussures",
        ["war_mode"] = "Mode guerre",
        ["check_plate"] = "Vérifier la plaque",
        ["remove_from_vehicle"] = "Sortir du véhicule",
        ["register_vehicle"] = "Mettre en fourrière",
        ["impound"] = "Fourrière",
        ["family"] = "Famille",
        ["evaluate_player"] = "Évaluer le joueur",
        ["fortune_wheel"] = "Roue de la fortune",
        ["seize_items"] = "Saisir les objets",

        -- Social Media Links
        ["instagram"] = "Instagram",
        ["tiktok"] = "TikTok",

        -- Yoga and Recreational Activities
        ["yoga"] = "Yoga",
        ["make_products"] = "Fabriquer des produits",
        ["slot_machine"] = "Machine à sous",

        -- Player and NPC Interactions
        ["talk"] = "Parler",
        ["frisk"] = "Fouiller",
        ["loot"] = "Fouiller",
        ["report_box"] = "Rapport",
        ["steal_vehicle"] = "Voler le véhicule",
        ["rate_player"] = "Noter le joueur",

        -- WallStreet and Economy-related
        ["start_wall_street"] = "Démarrer WallStreet",
        ["bank_operations"] = "Opérations bancaires",

        -- Fuel and Vehicle Maintenance
        ["fuel_vehicle"] = "Ravitaillement",
        ["check_oil"] = "Vérifier l'huile",

        -- Relationship Status
        ["relationship"] = "Relation",
        ["Solteiro"] = "Célibataire",
        ["married"] = "Marié",
        ["Namorando"] = "En couple",
        ["engaged"] = "Fiancé",
        ["relationships"] = "Se mettre en couple",

        -- Custom User Interactions
        ["family_status"] = "Statut famille",
        ["member"] = "Membre",
        ["leader"] = "Chef",

        -- Pets
        ["getup"] = "Se lever",
        ["sit"] = "S'asseoir",
        ["sleep"] = "Dormir",
        ["enterCar"] = "Monter dans la voiture",
        ["follow"] = "Suivre",
        ["guard"] = "Garder",
        ["exitCar"] = "Retirer le pet",
        ["changeName"] = "Changer le nom",
        ["entityTarget"] = "Interaction auditive.",

        ["beginner"] = "DÉBUTANT",
        ["rate"] = "Note",
        ["wanted"] = "RECHERCHÉ",
        ["lay_down"] = "S'allonger",
        ["treatment"] = "Traitement",
        ["fuel"] = "Ravitaillement",

        -- Vehicle Lock Status
        ["lock_vehicle"] = "Verrouiller [L]",
        ["unlock_vehicle"] = "Déverrouiller [L]",
        ["enter_vehicle"] = "Monter dans le véhicule [F]",

        -- Treatment Dialog
        ["treatment_request"] = "Poursuivre le traitement pour %s $ ?",
        ["treatment_accept"] = "Oui, commencer le traitement",
        ["treatment_decline"] = "Non, je reviendrai plus tard",
        ["dismantle"] = "Démonter",
        ["noVIP"] = "SANS VIP",

        ["under_evaluation"] = "en cours d'évaluation",

        ["commercial_team"] = "Équipe commerciale",

        ["call_mechanic_message"] = "Le véhicule ne démarre pas.",
        ["tow_vehicle"] = "Dépanner le véhicule",
        ["untow_vehicle"] = "Détacher le véhicule",

        ["level_social"] = "SOCIAL %s 💫",
    },

    ["pt-pt"] = {
        -- Ações de Caixa Eletrônico e Financeiras
        ["enter_apartment"] = "Entrar no Apartamento",
        ["rob_atm"] = "Roubar Caixa Multibanco",
        ["access_atm"] = "Aceder ao Caixa Multibanco",
    
        -- Lojas e Interações com Alimentos
        ["buy"] = "Comprar",
        ["drink"] = "Beber",
        ["fill"] = "Encher",
        ["assemble_combo"] = "Montar Combo",
        ["assemble_sandwich"] = "Montar Sanduíche",
        ["fill_cup"] = "Encher Copo",
        ["clean_vehicle"] = "Limpar Veículo",
        ["clean_vehicle_2"] = "Limpar Veículo 2",
    
        -- Chamada de Entrega
        ["call_deliverers"] = "Chamar Entregadores",
        ["call_burgershot"] = "Chamar Burger Shot",
        ["call_uwu_coffee"] = "Chamar UwU Coffee",
        ["call_pizza_this"] = "Chamar Pizza This",
        ["call_bean_machine"] = "Chamar Bean Machine",
    
        -- Interação com Itens/Objetos
        ["call_phone"] = "Ligar",
        ["hide"] = "Esconder",
        ["inspect"] = "Verificar",
        ["open"] = "Abrir",
        ["pick_up"] = "Pegar",
        ["destroy"] = "Destruir",
        ["open_trunk"] = "Abrir Porta-Malas",
        ["close_trunk"] = "Fechar Porta-Malas",
        ["check_trunk"] = "Checar Porta-Malas",
        ["check_item"] = "Checar Item",
    
        -- Serviços Médicos e de Emergência
        ["apply_plastic_surgery"] = "Aplicar Plástica",
        ["revive"] = "Reviver",
        ["lay_patient_down"] = "Deitar Paciente",
        ["apply_bandages"] = "Passar Ataduras",
        ["extract_blood"] = "Extrair Sangue",
        ["diagnosis"] = "Informações",
        ["treatment"] = "Tratamento",
        ["diagnostic"] = "Diagnóstico",
        ["surgical_procedures"] = "Procedimentos Cirúrgicos",
    
        -- Ações de Licença de Armas
        ["add_weapon_license"] = "Adicionar Licença de Armas",
        ["remove_weapon_license"] = "Remover Licença de Armas",
        ["check_weapon_license"] = "Verificar Licença de Armas",
    
        -- Interações com Veículos
        ["remove_tire"] = "Retirar Pneu",
        ["inspect_vehicle"] = "Inspecionar Veículo",
        ["fix_vehicle"] = "Reparar Veículo",
        ["enter_trunk"] = "Entrar no Porta-Malas",
        ["break_into_trunk"] = "Arrombar Porta-Malas",
        ["impound_vehicle"] = "Apreender Veículo",
        ["report_vehicle"] = "Reportar Veículo",
        ["repair_vehicle"] = "Reparar Veículo",
        ["create_duplicate_key"] = "Criar Chave Cópia",
        ["change_plate"] = "Trocar Placa",
        ["refuel"] = "Abastecer",
        ["roll_vehicle"] = "Desvirar Veículo",
        ["tow_vehicle"] = "Reboque de Veículo",
        ["steal_trunk"] = "Roubar Porta-Malas",
        ["remove_tyres"] = "Remover Pneus",
        ["call_mechanic"] = "Chamar Mecânico",
    
        -- Ações Diversas
        ["steal_shoes"] = "Roubar Sapatos",
        ["war_mode"] = "Modo Guerra",
        ["check_plate"] = "Verificar Placa",
        ["remove_from_vehicle"] = "Retirar do Veículo",
        ["register_vehicle"] = "Apreender Veículo",
        ["impound"] = "Apreender",
        ["family"] = "Família",
        ["evaluate_player"] = "Avaliar Jogador",
        ["fortune_wheel"] = "Roda da Fortuna",
        ["seize_items"] = "Apreender Itens",
    
        -- Links de Redes Sociais
        ["instagram"] = "Instagram",
        ["tiktok"] = "TikTok",
    
        -- Yoga e Atividades Recreativas
        ["yoga"] = "Yoga",
        ["make_products"] = "Fazer Produtos",
        ["slot_machine"] = "Máquina de Caça-Níqueis",
    
        -- Interações com Jogadores e NPCs
        ["talk"] = "Conversar",
        ["frisk"] = "Revistar",
        ["loot"] = "Saque",
        ["report_box"] = "Relatório",
        ["steal_vehicle"] = "Roubar Veículo",
        ["rate_player"] = "Avaliar Jogador",
    
        -- WallStreet e Economia
        ["start_wall_street"] = "Iniciar WallStreet",
        ["bank_operations"] = "Operações Bancárias",
    
        -- Combustível e Manutenção de Veículos
        ["fuel_vehicle"] = "Abastecer Combustível",
        ["check_oil"] = "Verificar Óleo",
    
        -- Status de Relacionamento
        ["relationship"] = "Relacionamento",
        ["Solteiro"] = "Solteiro",
        ["married"] = "Casado",
        ["Namorando"] = "Namorando",
        ["engaged"] = "Noivo",
        ["relationships"] = "Relacionar-se",
    
        -- Interações Personalizadas do Usuário
        ["family_status"] = "Status da Família",
        ["member"] = "Membro",
        ["leader"] = "Líder",
    
        -- Pets
        ["getup"] = "Levantar",
        ["sit"] = "Sentar",
        ["sleep"] = "Dormir",
        ["enterCar"] = "Entrar no Carro",
        ["follow"] = "Seguir",
        ["guard"] = "Guardar",
        ["exitCar"] = "Retirar Pet",
        ["changeName"] = "Mudar Nome",
        ["entityTarget"] = "Interação Auricular.",
    
        ["beginner"] = "INICIANTE",
        ["rate"] = "Nota",
        ["wanted"] = "PROCURADO",
        ["lay_down"] = "Deitar",
        ["treatment"] = "Tratamento",
        ["fuel"] = "Abastecer",
    
        -- Status de Trancamento de Veículo
        ["lock_vehicle"] = "Trancar [L]",
        ["unlock_vehicle"] = "Destrancar [L]",
        ["enter_vehicle"] = "Entrar no Veículo [F]",
    
        -- Diálogo de Tratamento
        ["treatment_request"] = "Prosseguir com o tratamento por $%s dólares?",
        ["treatment_accept"] = "Sim, iniciar tratamento",
        ["treatment_decline"] = "Não, volto mais tarde",
        ["dismantle"] = "Desmanchar",
        ["noVIP"] = "SEM VIP",

        ["under_evaluation"] = "em Avaliação",

        ["commercial_team"] = "Time Comercial",

        ["call_mechanic_message"] = "O veículo não liga.",
        ["tow_vehicle"] = "Guinchar veículo",
        ["untow_vehicle"] = "Soltar veículo",

        ["level_social"] = "SOCIAL %s 💫",
    },

    ["es-es"] = {
        -- ATM and Financial Actions
        ["enter_apartment"] = "Entrar Apartamento",
        ["rob_atm"] = "Robar Cajero Automático",
        ["access_atm"] = "Acceder Cajero Automático",

        -- Shops and Food-related Interactions
        ["buy"] = "Comprar",
        ["drink"] = "Beber",
        ["fill"] = "Llenar",
        ["assemble_combo"] = "Montar Combo",
        ["assemble_sandwich"] = "Montar Sandwich",
        ["fill_cup"] = "Llenar Vaso",
        ["clean_vehicle"] = "Limpiar Vehículo",
        ["clean_vehicle_2"] = "Limpiar Vehículo 2",

        -- Call Delivery
        ["call_deliverers"] = "Llamar Repartidores",
        ["call_burgershot"] = "Llamar Burger Shot",
        ["call_uwu_coffee"] = "Llamar UwU Coffee",
        ["call_pizza_this"] = "Llamar Pizza This",
        ["call_bean_machine"] = "Llamar Bean Machine",

        -- Interaction with Items/Objects
        ["call_phone"] = "Llamar",
        ["hide"] = "Ocultar",
        ["inspect"] = "Verificar",
        ["open"] = "Abrir",
        ["pick_up"] = "Recoger",
        ["destroy"] = "Destruir",
        ["open_trunk"] = "Abrir Maletero",
        ["close_trunk"] = "Cerrar Maletero",
        ["check_trunk"] = "Revisar Maletero",
        ["check_item"] = "Revisar Objeto",

        -- Medical and Emergency Services
        ["apply_plastic_surgery"] = "Aplicar Cirugía Plástica",
        ["revive"] = "Reanimar",
        ["lay_patient_down"] = "Acostar Paciente",
        ["apply_bandages"] = "Aplicar Vendajes",
        ["extract_blood"] = "Extraer Sangre",
        ["diagnosis"] = "Información",
        ["treatment"] = "Tratamiento",
        ["diagnostic"] = "Diagnóstico",
        ["surgical_procedures"] = "Procedimientos Quirúrgicos",

        -- Weapon License Actions
        ["add_weapon_license"] = "Añadir Licencia de Armas",
        ["remove_weapon_license"] = "Retirar Licencia de Armas",
        ["check_weapon_license"] = "Verificar Licencia de Armas",

        -- Vehicle Interactions
        ["remove_tire"] = "Quitar Neumático",
        ["inspect_vehicle"] = "Inspeccionar Vehículo",
        ["fix_vehicle"] = "Arreglar Vehículo",
        ["enter_trunk"] = "Entrar en Maletero",
        ["break_into_trunk"] = "Forzar Maletero",
        ["impound_vehicle"] = "Incautar Vehículo",
        ["report_vehicle"] = "Reportar Vehículo",
        ["repair_vehicle"] = "Reparar Vehículo",
        ["create_duplicate_key"] = "Crear Llave Duplicada",
        ["change_plate"] = "Cambiar Matrícula",
        ["refuel"] = "Repostar",
        ["roll_vehicle"] = "Enderezar Vehículo",
        ["tow_vehicle"] = "Remolcar Vehículo",
        ["steal_trunk"] = "Robar Maletero",
        ["remove_tyres"] = "Quitar Neumáticos",
        ["call_mechanic"] = "Llamar Mecánico",

        -- Miscellaneous Actions
        ["steal_shoes"] = "Robar Zapatos",
        ["war_mode"] = "Modo Guerra",
        ["check_plate"] = "Verificar Matrícula",
        ["remove_from_vehicle"] = "Sacar del Vehículo",
        ["register_vehicle"] = "Incautar Vehículo",
        ["impound"] = "Incautar",
        ["family"] = "Familia",
        ["evaluate_player"] = "Evaluar Jugador",
        ["fortune_wheel"] = "Rueda de la Fortuna",
        ["seize_items"] = "Incautar Objetos",

        -- Social Media Links
        ["instagram"] = "Instagram",
        ["tiktok"] = "TikTok",

        -- Yoga and Recreational Activities
        ["yoga"] = "Yoga",
        ["make_products"] = "Fabricar Productos",
        ["slot_machine"] = "Tragamonedas",

        -- Player and NPC Interactions
        ["talk"] = "Hablar",
        ["frisk"] = "Registrar",
        ["loot"] = "Saqueo",
        ["report_box"] = "Informe",
        ["steal_vehicle"] = "Robar Vehículo",
        ["rate_player"] = "Evaluar Jugador",

        -- WallStreet and Economy-related
        ["start_wall_street"] = "Iniciar WallStreet",
        ["bank_operations"] = "Operaciones Bancarias",

        -- Fuel and Vehicle Maintenance
        ["fuel_vehicle"] = "Repostar Combustible",
        ["check_oil"] = "Verificar Aceite",

        -- Relationship Status
        ["relationship"] = "Relación",
        ["Solteiro"] = "Soltero",
        ["married"] = "Casado",
        ["Namorando"] = "Novio/a",
        ["engaged"] = "Prometido",
        ["relationships"] = "Relacionarse",

        -- Custom User Interactions
        ["family_status"] = "Estado Familiar",
        ["member"] = "Miembro",
        ["leader"] = "Líder",

        -- Pets
        ["getup"] = "Levantar",
        ["sit"] = "Sentar",
        ["sleep"] = "Dormir",
        ["enterCar"] = "Entrar al Coche",
        ["follow"] = "Seguir",
        ["guard"] = "Guardar",
        ["exitCar"] = "Sacar Mascota",
        ["changeName"] = "Cambiar Nombre",
        ["entityTarget"] = "Interacción auricular.",

        ["beginner"] = "PRINCIPIANTE",
        ["rate"] = "Nota",
        ["wanted"] = "BUSCADO",
        ["lay_down"] = "Acostar",
        ["treatment"] = "Tratamiento",
        ["fuel"] = "Repostar",

        -- Vehicle Lock Status
        ["lock_vehicle"] = "Bloquear [L]",
        ["unlock_vehicle"] = "Desbloquear [L]",
        ["enter_vehicle"] = "Entrar al Vehículo [F]",

        -- Treatment Dialog
        ["treatment_request"] = "¿Proceder con el tratamiento por $%s dólares?",
        ["treatment_accept"] = "Sí, iniciar tratamiento",
        ["treatment_decline"] = "No, volveré más tarde",
        ["dismantle"] = "Desmontar",
        ["noVIP"] = "SIN VIP",

        ["under_evaluation"] = "en Evaluación",

        ["commercial_team"] = "Equipo Comercial",

        ["call_mechanic_message"] = "El vehículo no arranca.",
        ["tow_vehicle"] = "Remolcar vehículo",
        ["untow_vehicle"] = "Liberar vehículo",

        ["level_social"] = "SOCIAL %s 💫",
    },

    ["de-de"] = {
        ["enter_apartment"] = "Wohnung betreten",
        ["rob_atm"] = "Geldautomaten ausrauben",
        ["access_atm"] = "Geldautomaten nutzen",
        ["buy"] = "Kaufen",
        ["drink"] = "Trinken",
        ["fill"] = "Füllen",
        ["assemble_combo"] = "Combo zusammenstellen",
        ["assemble_sandwich"] = "Sandwich belegen",
        ["fill_cup"] = "Becher füllen",
        ["clean_vehicle"] = "Fahrzeug waschen",
        ["clean_vehicle_2"] = "Fahrzeug waschen 2",
        ["call_deliverers"] = "Lieferanten rufen",
        ["call_burgershot"] = "Burger Shot rufen",
        ["call_uwu_coffee"] = "UwU Coffee rufen",
        ["call_pizza_this"] = "Pizza This rufen",
        ["call_bean_machine"] = "Bean Machine rufen",
        ["call_phone"] = "Anrufen",
        ["hide"] = "Verstecken",
        ["inspect"] = "Prüfen",
        ["open"] = "Öffnen",
        ["pick_up"] = "Aufheben",
        ["destroy"] = "Zerstören",
        ["open_trunk"] = "Kofferraum öffnen",
        ["close_trunk"] = "Kofferraum schließen",
        ["check_trunk"] = "Kofferraum prüfen",
        ["check_item"] = "Gegenstand prüfen",
        ["apply_plastic_surgery"] = "Plastische Chirurgie anwenden",
        ["revive"] = "Wiederbeleben",
        ["lay_patient_down"] = "Patient hinlegen",
        ["apply_bandages"] = "Verbände anlegen",
        ["extract_blood"] = "Blut abnehmen",
        ["diagnosis"] = "Diagnose",
        ["treatment"] = "Behandlung",
        ["diagnostic"] = "Diagnostik",
        ["surgical_procedures"] = "Chirurgische Eingriffe",
        ["add_weapon_license"] = "Waffenschein hinzufügen",
        ["remove_weapon_license"] = "Waffenschein entziehen",
        ["check_weapon_license"] = "Waffenschein prüfen",
        ["remove_tire"] = "Reifen entfernen",
        ["inspect_vehicle"] = "Fahrzeug prüfen",
        ["fix_vehicle"] = "Fahrzeug reparieren",
        ["enter_trunk"] = "In Kofferraum einsteigen",
        ["break_into_trunk"] = "Kofferraum aufbrechen",
        ["impound_vehicle"] = "Fahrzeug beschlagnahmen",
        ["report_vehicle"] = "Fahrzeug melden",
        ["repair_vehicle"] = "Fahrzeug reparieren",
        ["create_duplicate_key"] = "Ersatzschlüssel anfertigen",
        ["change_plate"] = "Kennzeichen ändern",
        ["refuel"] = "Tanken",
        ["roll_vehicle"] = "Fahrzeug umdrehen",
        ["tow_vehicle"] = "Fahrzeug abschleppen",
        ["steal_trunk"] = "Kofferraum ausrauben",
        ["remove_tyres"] = "Reifen entfernen",
        ["clean_vehicle"] = "Fahrzeug waschen",
        ["register_vehicle"] = "Fahrzeug beschlagnahmen",
        ["call_mechanic"] = "Mechaniker rufen",
        ["steal_shoes"] = "Schuhe stehlen",
        ["war_mode"] = "Kriegsmodus",
        ["check_plate"] = "Kennzeichen prüfen",
        ["remove_from_vehicle"] = "Aus Fahrzeug entfernen",
        ["impound"] = "Beschlagnahmen",
        ["family"] = "Familie",
        ["evaluate_player"] = "Spieler bewerten",
        ["fortune_wheel"] = "Glücksrad",
        ["seize_items"] = "Gegenstände beschlagnahmen",
        ["instagram"] = "Instagram",
        ["tiktok"] = "TikTok",
        ["yoga"] = "Yoga",
        ["make_products"] = "Produkte herstellen",
        ["slot_machine"] = "Spielautomat",
        ["talk"] = "Sprechen",
        ["frisk"] = "Durchsuchen",
        ["loot"] = "Plündern",
        ["report_box"] = "Meldung",
        ["steal_vehicle"] = "Fahrzeug stehlen",
        ["rate_player"] = "Spieler bewerten",
        ["start_wall_street"] = "WallStreet starten",
        ["bank_operations"] = "Bankgeschäfte",
        ["fuel_vehicle"] = "Fahrzeug betanken",
        ["check_oil"] = "Öl prüfen",
        ["relationship"] = "Beziehung",
        ["Solteiro"] = "Single",
        ["married"] = "Verheiratet",
        ["Namorando"] = "In einer Beziehung",
        ["engaged"] = "Verlobt",
        ["relationships"] = "Beziehung",
        ["family_status"] = "Familienstatus",
        ["member"] = "Mitglied",
        ["leader"] = "Anführer",
        ["getup"] = "Aufstehen",
        ["sit"] = "Sitzen",
        ["sleep"] = "Schlafen",
        ["enterCar"] = "Ins Auto einsteigen",
        ["follow"] = "Folgen",
        ["guard"] = "Bewachen",
        ["exitCar"] = "Haustier aus dem Auto holen",
        ["changeName"] = "Haustier umbenennen",
        ["entityTarget"] = "Ohrhörer-Interaktion.",
        ["beginner"] = "ANFÄNGER",
        ["rate"] = "Bewerten",
        ["wanted"] = "GESUCHT",
        ["lay_down"] = "Hinlegen",
        ["treatment"] = "Behandlung",
        ["fuel"] = "Tanken",
        ["lock_vehicle"] = "Abschließen [L]",
        ["unlock_vehicle"] = "Aufschließen [L]",
        ["enter_vehicle"] = "Fahrzeug betreten [F]",
        ["treatment_request"] = "Behandlung für $%s durchführen?",
        ["treatment_accept"] = "Ja, Behandlung starten",
        ["treatment_decline"] = "Nein, ich komme später wieder",
        ["dismantle"] = "Demontieren",
        ["noVIP"] = "KEIN VIP",
        ["under_evaluation"] = "In Bewertung",
        ["commercial_team"] = "Verkaufsteam",
        ["call_mechanic_message"] = "Das Fahrzeug startet nicht.",
        ["tow_vehicle"] = "Fahrzeug abschleppen",
        ["untow_vehicle"] = "Fahrzeug losmachen",

        ["level_social"] = "SOZIAL %s 💫",
    },

    ["ar-sa"] = {
        -- ATM and Financial Actions
        ["enter_apartment"] = "دخول الشقة",
        ["rob_atm"] = "سرقة الصراف الآلي",
        ["access_atm"] = "الوصول إلى الصراف الآلي",

        -- Shops and Food-related Interactions
        ["buy"] = "شراء",
        ["drink"] = "شرب",
        ["fill"] = "تعبئة",
        ["assemble_combo"] = "تجميع الوجبة",
        ["assemble_sandwich"] = "تجميع الساندويتش",
        ["fill_cup"] = "ملء الكوب",
        ["clean_vehicle"] = "تنظيف المركبة",
        ["clean_vehicle_2"] = "تنظيف المركبة 2",

        -- Call Delivery
        ["call_deliverers"] = "استدعاء مندوبي التوصيل",
        ["call_burgershot"] = "استدعاء برجر شوت",
        ["call_uwu_coffee"] = "استدعاء أووو كوفي",
        ["call_pizza_this"] = "استدعاء بيتزا ذيس",
        ["call_bean_machine"] = "استدعاء بين مشين",

        -- Interaction with Items/Objects
        ["call_phone"] = "اتصال",
        ["hide"] = "إخفاء",
        ["inspect"] = "فحص",
        ["open"] = "فتح",
        ["pick_up"] = "التقاط",
        ["destroy"] = "تدمير",
        ["open_trunk"] = "فتح الصندوق",
        ["close_trunk"] = "إغلاق الصندوق",
        ["check_trunk"] = "فحص الصندوق",
        ["check_item"] = "فحص العنصر",

        -- Medical and Emergency Services
        ["apply_plastic_surgery"] = "إجراء عملية تجميلية",
        ["revive"] = "إنعاش",
        ["lay_patient_down"] = "إنزال المريض",
        ["apply_bandages"] = "وضع ضمادات",
        ["extract_blood"] = "سحب الدم",
        ["diagnosis"] = "تشخيص",
        ["treatment"] = "علاج",
        ["diagnostic"] = "تشخيص طبي",
        ["surgical_procedures"] = "إجراءات جراحية",

        -- Weapon License Actions
        ["add_weapon_license"] = "إضافة رخصة سلاح",
        ["remove_weapon_license"] = "إزالة رخصة سلاح",
        ["check_weapon_license"] = "التحقق من رخصة السلاح",

        -- Vehicle Interactions
        ["remove_tire"] = "إزالة الإطار",
        ["inspect_vehicle"] = "فحص المركبة",
        ["fix_vehicle"] = "إصلاح المركبة",
        ["enter_trunk"] = "الدخول إلى الصندوق",
        ["break_into_trunk"] = "كسر الصندوق",
        ["impound_vehicle"] = "حجز المركبة",
        ["report_vehicle"] = "الإبلاغ عن المركبة",
        ["repair_vehicle"] = "إصلاح المركبة",
        ["create_duplicate_key"] = "إنشاء مفتاح احتياطي",
        ["change_plate"] = "تغيير اللوحة",
        ["refuel"] = "تزود بالوقود",
        ["roll_vehicle"] = "قلب المركبة",
        ["tow_vehicle"] = "سحب المركبة",
        ["steal_trunk"] = "سرقة صندوق السيارة",
        ["remove_tyres"] = "إزالة الإطارات",
        ["clean_vehicle"] = "تنظيف المركبة",
        ["register_vehicle"] = "حجز المركبة",
        ["call_mechanic"] = "استدعاء ميكانيكي",

        -- Miscellaneous Actions
        ["steal_shoes"] = "سرقة الأحذية",
        ["war_mode"] = "وضع الحرب",
        ["check_plate"] = "التحقق من اللوحة",
        ["remove_from_vehicle"] = "إزالة من المركبة",
        ["impound"] = "حجز",
        ["family"] = "العائلة",
        ["evaluate_player"] = "تقييم اللاعب",
        ["fortune_wheel"] = "عجلة الحظ",
        ["seize_items"] = "مصادرة العناصر",

        -- Social Media Links
        ["instagram"] = "إنستغرام",
        ["tiktok"] = "تيك توك",

        -- Yoga and Recreational Activities
        ["yoga"] = "اليوغا",
        ["make_products"] = "صنع المنتجات",
        ["slot_machine"] = "آلة القمار",

        -- Player and NPC Interactions
        ["talk"] = "تحدث",
        ["frisk"] = "تفتيش",
        ["loot"] = "نهب",
        ["report_box"] = "صندوق الإبلاغ",
        ["steal_vehicle"] = "سرقة المركبة",
        ["rate_player"] = "تقييم اللاعب",

        -- WallStreet and Economy-related
        ["start_wall_street"] = "بدء وول ستريت",
        ["bank_operations"] = "عمليات بنكية",

        -- Fuel and Vehicle Maintenance
        ["fuel_vehicle"] = "تزويد المركبة بالوقود",
        ["check_oil"] = "فحص الزيت",

        -- Relationship Status
        ["relationship"] = "العلاقة",
        ["Solteiro"] = "أعزب",
        ["married"] = "متزوج",
        ["Namorando"] = "في علاقة",
        ["engaged"] = "مخطوب",
        ["relationships"] = "العلاقات",

        -- Custom User Interactions
        ["family_status"] = "حالة العائلة",
        ["member"] = "عضو",
        ["leader"] = "قائد",

        ["getup"] = "النهوض",
        ["sit"] = "الجلوس",
        ["sleep"] = "النوم",
        ["enterCar"] = "الدخول إلى السيارة",
        ["follow"] = "المتابعة",
        ["guard"] = "الحماية",
        ["exitCar"] = "إخراج الحيوان من السيارة",
        ["changeName"] = "تغيير الاسم",

        ["entityTarget"] = "تفاعل سماعي.",

        ["beginner"] = "مبتدئ",
        ["rate"] = "تقييم",
        ["wanted"] = "مطلوب",
        ["lay_down"] = "الاستلقاء",
        ["treatment"] = "علاج",
        ["fuel"] = "تزود بالوقود",

        -- Vehicle Lock Status
        ["lock_vehicle"] = "قفل [L]",
        ["unlock_vehicle"] = "فتح القفل [L]",
        ["enter_vehicle"] = "الدخول إلى المركبة [F]",

        -- Treatment Dialog
        ["treatment_request"] = "المتابعة في العلاج مقابل $%s؟",
        ["treatment_accept"] = "نعم، بدء العلاج",
        ["treatment_decline"] = "لا، سأعود لاحقاً",
        ["dismantle"] = "تفكيك",
        ["noVIP"] = "لا يوجد VIP",

        ["under_evaluation"] = "قيد التقييم",

        ["commercial_team"] = "الفريق التجاري",

        ["call_mechanic_message"] = "المركبة لا تعمل.",
        ["tow_vehicle"] = "سحب المركبة",
        ["untow_vehicle"] = "تحرير المركبة",

        ["level_social"] = "اجتماعي %s 💫",
    }
}

---@param key string The translation key to check
---@return boolean Returns true if translation exists, false otherwise
function CheckTranslation(key)
    if not translations[lang] then
        print("[DEBUG] Translation not found for Lang: " .. lang)
        return false
    end
    if translations[lang][key] then
        return true
    else
        print("[DEBUG] Translation not found for key: " .. key.. " - Lang: " .. lang)
        return false
    end
end

---@param key string The translation key to retrieve
---@return string Returns the translated string or error message
function _t(key)
    if CheckTranslation(key) then
        return translations[lang][key]
    else
        return "Translation not found for key: " .. key.. " - Lang: " .. lang
    end
end