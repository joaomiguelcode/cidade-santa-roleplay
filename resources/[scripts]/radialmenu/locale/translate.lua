lang = GetConvar("language", "pt-br")
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
        ["clean_vehicle"] = "Clean Vehicle",
        ["register_vehicle"] = "Impound Vehicle",
        ["put_in_vehicle_label"] = "Put in Vehicle",

        -- Miscellaneous Actions
        ["steal_shoes"] = "Steal Shoes",
        ["war_mode"] = "War Mode",
        ["check_plate"] = "Check Plate",
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
        ["recruit_interaction"] = "Recruit",
        ["put_in_vehicle"] = "Put in Vehicle",
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
        ["open_radial_menu"] = "Abrir Radial Menu",
        ["officer_menu"] = "Officer Menu",
        ["interact_player"] = "Interactions",
        ["matchcity_view_profile"] = "View profile",
        ["matchcity_add_contact"] = "Add contact",
        ["like"] = "Like",
        ["negociar"] = "Negotiate",
        ["evaluate_player"] = "Evaluate Player",
        ["open_perfil"] = "Open Profile",
        ["paramedic_menu"] = "Paramedic Menu",
        ["bombeiros_menu"] = "Firemen Menu",
        ["open_animations"] = "Open Animations",
        ["open_sentimentals"] = "Open Sentimentals",
        ["open_carry"] = "Open Carry",
        ["open_dance"] = "Open Dance",
        ["open_couple"] = "Open Couple",
        ["kiss"] = "Kiss",
        ["relationship_already_taken"] = "%s is already in a relationship with %s. Do you want to ask them out anyway?",
        ["relationship_request"] = "%s wants to DATE you.",
        ["relationship_request_married"] = "%s wants to get MARRIED with you.",
        ["relationship_finish_confirmation"] = "Are you sure you want to end your relationship?",
        ["abraco"] = "Hug",
        ["abracocintura"] = "Hug on waist",
        ["cavalinho"] = "Hug on shoulder",
        ["dancinha1"] = "Dance 1",
        ["dancinha2"] = "Dance 2",
        ["ombro"] = "Shoulder",
        ["carregar"] = "Carry",
        ["carregar4"] = "Carry 4",
        ["carregar2"] = "Carry 2",  
        ["massagemcosta"] = "Massage on back",
        ["massagemperna"] = "Massage on stomach",
        ["maosdadas2"] = "Handshake 2",
        ["maosdadas3"] = "Handshake 3",
        ["dancinha1"] = "Dance 1",
        ["dancinha2"] = "Dance 2",
        ["dancinha3"] = "Dance 3",
        ["dancinha4"] = "Dance 4",

        ["tickets.create_commercial_direct_ticket"] = "Start Commercial Ticket",
    },

    ["pt-br"] = {
        ["relationships"] = "Relacionar-se",
        ["start_wall_street"] = "Iniciar WallStreet",
        
        -- Medical and Emergency Services
        ["revive"] = "Reviver",
        ["apply_plastic_surgery"] = "Aplicar Plástica",
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
        

        ["bombeiros_menu"] = "Bombeiros Menu",
        
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
        ["put_in_vehicle_label"] = "Colocar no Veículo",

        -- Miscellaneous Actions
        ["steal_shoes"] = "Roubar Sapatos",
        ["war_mode"] = "Modo Guerra",
        ["check_plate"] = "Verificar Placa",
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
        ["recruit_interaction"] = "Recrutar",
        ["put_in_vehicle"] = "Colocar no Veículo",
        ["loot"] = "Saque",
        ["report_box"] = "Relatório",
        ["steal_vehicle"] = "Roubar Veículo",
        ["rate_player"] = "Avaliar Jogador",

        -- WallStreet and Economy-related
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
        ["open_radial_menu"] = "Abrir Radial Menu",
        ["officer_menu"] = "Menu de Policial",
        ["interact_player"] = "Interações",
        ["matchcity_view_profile"] = "Ver perfil",
        ["matchcity_add_contact"] = "Adicionar contato",
        ["like"] = "Dar Like",
        ["negociar"] = "Negociar",
        ["evaluate_player"] = "Avaliar Jogador",
        ["open_perfil"] = "Abrir Perfil",
        ["paramedic_menu"] = "Menu de Paramedico",
        ["open_animations"] = "Abrir Animações",
        ["open_sentimentals"] = "Abrir Sentimentais",
        ["open_carry"] = "Abrir Carregar",
        ["open_dance"] = "Abrir Dançar",
        ["open_couple"] = "Abrir Casal",
        ["kiss"] = "Beijar",
        ["abraco"] = "Abraço",
        ["abracocintura"] = "Abraço na cintura",
        ["cavalinho"] = "Cavalinho",
        ["dancinha1"] = "Dança 1",
        ["dancinha2"] = "Dança 2",
        ["dancinha3"] = "Dança 3",
        ["dancinha4"] = "Dança 4",
        ["ombro"] = "Ombro",
        ["carregar"] = "Carregar",
        ["carregar4"] = "Carregar 4",
        ["carregar2"] = "Carregar 2",
        ["relationship_already_taken"] = "%s já está em relacionamento com %s. Deseja pedir em namoro mesmo assim?",
        ["relationship_request"] = "%s quer NAMORAR com você.",
        ["relationship_request_married"] = "%s quer se CASAR com você.",
        ["relationship_finish_confirmation"] = "Você tem certeza que deseja terminar seu relacionamento?",

        ["tickets.create_commercial_direct_ticket"] = "Iniciar Atendimento Comercial",
    },

    ["es-es"] = {
        ["relationships"] = "Relacionarse",
        ["start_wall_street"] = "Iniciar WallStreet",
        
        -- Medical and Emergency Services
        ["revive"] = "Revivir",
        ["apply_plastic_surgery"] = "Aplicar Cirugía Plástica",
        ["lay_patient_down"] = "Acostar Paciente",
        ["apply_bandages"] = "Aplicar Vendajes",
        ["extract_blood"] = "Extraer Sangre",
        ["diagnosis"] = "Informaciones",
        ["treatment"] = "Tratamiento",
        ["diagnostic"] = "Diagnóstico",
        ["surgical_procedures"] = "Procedimientos Quirúrgicos",

        -- Weapon License Actions
        ["add_weapon_license"] = "Añadir Licencia de Armas",
        ["remove_weapon_license"] = "Remover Licencia de Armas",
        ["check_weapon_license"] = "Verificar Licencia de Armas",
        

        ["bombeiros_menu"] = "Menú de Bomberos",
        
        -- ATM and Financial Actions
        ["enter_apartment"] = "Entrar Apartamento",
        ["rob_atm"] = "Robar Cajero Automático",
        ["access_atm"] = "Acceder Cajero Automático",

        -- Shops and Food-related Interactions
        ["buy"] = "Comprar",
        ["drink"] = "Beber",
        ["fill"] = "Llenar",
        ["assemble_combo"] = "Montar Combo",
        ["assemble_sandwich"] = "Montar Bocadillo",
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
        ["hide"] = "Esconder",
        ["inspect"] = "Verificar",
        ["open"] = "Abrir",
        ["pick_up"] = "Coger",
        ["destroy"] = "Destruir",
        ["open_trunk"] = "Abrir Maletero",
        ["close_trunk"] = "Cerrar Maletero",
        ["check_trunk"] = "Revisar Maletero",
        ["check_item"] = "Revisar Objeto",




        -- Vehicle Interactions
        ["remove_tire"] = "Quitar Neumático",
        ["inspect_vehicle"] = "Inspeccionar Vehículo",
        ["fix_vehicle"] = "Reparar Vehículo",
        ["enter_trunk"] = "Entrar en el Maletero",
        ["break_into_trunk"] = "Forzar Maletero",
        ["impound_vehicle"] = "Incautar Vehículo",
        ["report_vehicle"] = "Reportar Vehículo",
        ["repair_vehicle"] = "Reparar Vehículo",
        ["create_duplicate_key"] = "Crear Llave Copia",
        ["change_plate"] = "Cambiar Matrícula",
        ["refuel"] = "Repostar",
        ["roll_vehicle"] = "Voltear Vehículo",
        ["tow_vehicle"] = "Remolcar Vehículo",
        ["steal_trunk"] = "Robar Maletero",
        ["remove_tyres"] = "Quitar Neumáticos",
        ["put_in_vehicle_label"] = "Poner en el Vehículo",

        -- Miscellaneous Actions
        ["steal_shoes"] = "Robar Zapatos",
        ["war_mode"] = "Modo Guerra",
        ["check_plate"] = "Verificar Matrícula",
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
        ["make_products"] = "Hacer Productos",
        ["slot_machine"] = "Máquina Tragaperras",

        -- Player and NPC Interactions
        ["talk"] = "Conversar",
        ["frisk"] = "Cachear",
        ["recruit_interaction"] = "Reclutar",
        ["put_in_vehicle"] = "Colocar en el Vehículo",
        ["loot"] = "Saquear",
        ["report_box"] = "Reporte",
        ["steal_vehicle"] = "Robar Vehículo",
        ["rate_player"] = "Evaluar Jugador",

        -- WallStreet and Economy-related
        ["bank_operations"] = "Operaciones Bancarias",

        -- Fuel and Vehicle Maintenance
        ["fuel_vehicle"] = "Repostar Combustible",
        ["check_oil"] = "Verificar Aceite",

        -- Relationship Status
        ["relationship"] = "Relación",
        ["Solteiro"] = "Soltero",
        ["married"] = "Casado",
        ["Namorando"] = "Saliendo",
        ["engaged"] = "Comprometido",

        -- Custom User Interactions
        ["family_status"] = "Estado Familiar",
        ["member"] = "Miembro",
        ["leader"] = "Líder",

        -- Pets
        ["getup"] = "Levantar",
        ["sit"] = "Sentar",
        ["sleep"] = "Dormir",
        ["enterCar"] = "Entrar en el coche",
        ["follow"] = "Seguir",
        ["guard"] = "Guardar",
        ["exitCar"] = "Sacar Mascota",
        ["changeName"] = "Cambiar Nombre",
        ["open_radial_menu"] = "Abrir Menú Radial",
        ["officer_menu"] = "Menú de Policía",
        ["interact_player"] = "Interacciones",
        ["matchcity_view_profile"] = "Ver perfil",
        ["matchcity_add_contact"] = "Agregar contacto",
        ["like"] = "Dar Me Gusta",
        ["negociar"] = "Negociar",
        ["evaluate_player"] = "Evaluar Jugador",
        ["open_perfil"] = "Abrir Perfil",
        ["paramedic_menu"] = "Menú de Paramédico",
        ["open_animations"] = "Abrir Animaciones",
        ["open_sentimentals"] = "Abrir Sentimentales",
        ["open_carry"] = "Abrir Cargar",
        ["open_dance"] = "Abrir Bailar",
        ["open_couple"] = "Abrir Pareja",
        ["kiss"] = "Besar",
        ["abraco"] = "Abrazo",
        ["abracocintura"] = "Abrazo en la cintura",
        ["cavalinho"] = "Caballito",
        ["dancinha1"] = "Baile 1",
        ["dancinha2"] = "Baile 2",
        ["dancinha3"] = "Baile 3",
        ["dancinha4"] = "Baile 4",
        ["ombro"] = "Hombro",
        ["carregar"] = "Cargar",
        ["carregar4"] = "Cargar 4",
        ["carregar2"] = "Cargar 2",
        ["relationship_already_taken"] = "%s ya está en una relación con %s. ¿Quieres pedirle salir de todos modos?",
        ["relationship_request"] = "%s quiere NAMORAR con usted.",
        ["relationship_request_married"] = "%s quiere CASARSE con usted.",
        ["relationship_finish_confirmation"] = "¿Estás seguro de querer terminar tu relación?",

        ["tickets.create_commercial_direct_ticket"] = "Iniciar Atención Comercial",
    },
    
    ["pt-pt"] = {
        ["relationships"] = "Relacionamentos",
        ["start_wall_street"] = "Iniciar WallStreet",
        
        -- Serviços Médicos e de Emergência
        ["revive"] = "Reanimar",
        ["apply_plastic_surgery"] = "Aplicar Cirurgia Plástica",
        ["lay_patient_down"] = "Deitar Paciente",
        ["apply_bandages"] = "Aplicar Ligaduras",
        ["extract_blood"] = "Extrair Sangue",
        ["diagnosis"] = "Informações",
        ["treatment"] = "Tratamento",
        ["diagnostic"] = "Diagnóstico",
        ["surgical_procedures"] = "Procedimentos Cirúrgicos",

        -- Ações Relacionadas à Licença de Armas
        ["add_weapon_license"] = "Adicionar Licença de Armas",
        ["remove_weapon_license"] = "Remover Licença de Armas",
        ["check_weapon_license"] = "Verificar Licença de Armas",

        ["bombeiros_menu"] = "Menu de Bombeiros",

        -- Ações Bancárias e Financeiras
        ["enter_apartment"] = "Entrar no Apartamento",
        ["rob_atm"] = "Assaltar Caixa Multibanco",
        ["access_atm"] = "Aceder ao Caixa Multibanco",

        -- Lojas e Interações Relacionadas com Alimentação
        ["buy"] = "Comprar",
        ["drink"] = "Beber",
        ["fill"] = "Encher",
        ["assemble_combo"] = "Montar Menu",
        ["assemble_sandwich"] = "Montar Sandes",
        ["fill_cup"] = "Encher Copo",
        ["clean_vehicle"] = "Limpar Veículo",
        ["clean_vehicle_2"] = "Limpar Veículo 2",

        -- Chamar Entregas
        ["call_deliverers"] = "Chamar Estafetas",
        ["call_burgershot"] = "Chamar Burger Shot",
        ["call_uwu_coffee"] = "Chamar UwU Coffee",
        ["call_pizza_this"] = "Chamar Pizza This",
        ["call_bean_machine"] = "Chamar Bean Machine",

        -- Interação com Itens/Objetos
        ["call_phone"] = "Telefonar",
        ["hide"] = "Esconder",
        ["inspect"] = "Verificar",
        ["open"] = "Abrir",
        ["pick_up"] = "Apanhar",
        ["destroy"] = "Destruir",
        ["open_trunk"] = "Abrir Porta-Bagagens",
        ["close_trunk"] = "Fechar Porta-Bagagens",
        ["check_trunk"] = "Verificar Porta-Bagagens",
        ["check_item"] = "Verificar Item",

        -- Interações com Veículos
        ["remove_tire"] = "Remover Pneu",
        ["inspect_vehicle"] = "Inspecionar Veículo",
        ["fix_vehicle"] = "Reparar Veículo",
        ["enter_trunk"] = "Entrar no Porta-Bagagens",
        ["break_into_trunk"] = "Arrombar Porta-Bagagens",
        ["impound_vehicle"] = "Apreender Veículo",
        ["report_vehicle"] = "Denunciar Veículo",
        ["repair_vehicle"] = "Reparar Veículo",
        ["create_duplicate_key"] = "Criar Chave Cópia",
        ["change_plate"] = "Trocar Matrícula",
        ["refuel"] = "Abastecer",
        ["roll_vehicle"] = "Desvirar Veículo",
        ["tow_vehicle"] = "Rebocar Veículo",
        ["steal_trunk"] = "Roubar Porta-Bagagens",
        ["remove_tyres"] = "Remover Pneus",
        ["put_in_vehicle_label"] = "Colocar no Veículo",

        -- Ações Diversas
        ["steal_shoes"] = "Roubar Sapatos",
        ["war_mode"] = "Modo Guerra",
        ["check_plate"] = "Verificar Matrícula",
        ["register_vehicle"] = "Registar Veículo",
        ["impound"] = "Apreender",
        ["family"] = "Família",
        ["evaluate_player"] = "Avaliar Jogador",
        ["fortune_wheel"] = "Roda da Fortuna",
        ["seize_items"] = "Apreender Itens",

        -- Ligações às Redes Sociais
        ["instagram"] = "Instagram",
        ["tiktok"] = "TikTok",

        -- Yoga e Atividades Recreativas
        ["yoga"] = "Yoga",
        ["make_products"] = "Criar Produtos",
        ["slot_machine"] = "Máquina de Slots",

        -- Interações com Jogadores e NPCs
        ["talk"] = "Conversar",
        ["frisk"] = "Revistar",
        ["recruit_interaction"] = "Recrutar",
        ["put_in_vehicle"] = "Colocar no Veículo",
        ["loot"] = "Saque",
        ["report_box"] = "Relatório",
        ["steal_vehicle"] = "Roubar Veículo",
        ["rate_player"] = "Avaliar Jogador",

        -- WallStreet e Economia
        ["bank_operations"] = "Operações Bancárias",

        -- Combustível e Manutenção de Veículos
        ["fuel_vehicle"] = "Abastecer Combustível",
        ["check_oil"] = "Verificar Óleo",

        -- Estado de Relacionamento
        ["relationship"] = "Relacionamento",
        ["Solteiro"] = "Solteiro",
        ["married"] = "Casado",
        ["Namorando"] = "A Namorar",
        ["engaged"] = "Noivo",

        -- Interações Personalizadas do Jogador
        ["family_status"] = "Estado da Família",
        ["member"] = "Membro",
        ["leader"] = "Líder",

        -- Animais de Estimação
        ["getup"] = "Levantar",
        ["sit"] = "Sentar",
        ["sleep"] = "Dormir",
        ["enterCar"] = "Entrar no Carro",
        ["follow"] = "Seguir",
        ["guard"] = "Guardar",
        ["exitCar"] = "Retirar Animal",
        ["changeName"] = "Mudar Nome",
        ["open_radial_menu"] = "Abrir Menu Radial",
        ["officer_menu"] = "Menu de Polícia",
        ["interact_player"] = "Interações",
        ["matchcity_view_profile"] = "Ver perfil",
        ["matchcity_add_contact"] = "Adicionar contacto",
        ["like"] = "Gostar",
        ["negociar"] = "Negociar",
        ["evaluate_player"] = "Avaliar Jogador",
        ["open_perfil"] = "Abrir Perfil",
        ["paramedic_menu"] = "Menu de Paramédico",
        ["open_animations"] = "Abrir Animações",
        ["open_sentimentals"] = "Abrir Sentimentais",
        ["open_carry"] = "Abrir Transporte",
        ["open_dance"] = "Abrir Dança",
        ["open_couple"] = "Abrir Casal",
        ["kiss"] = "Beijar",
        ["abraco"] = "Abraço",
        ["abracocintura"] = "Abraço na Cintura",
        ["cavalinho"] = "Cavalinho",
        ["dancinha1"] = "Dança 1",
        ["dancinha2"] = "Dança 2",
        ["dancinha3"] = "Dança 3",
        ["dancinha4"] = "Dança 4",
        ["ombro"] = "Ombro",
        ["carregar"] = "Transportar",
        ["carregar4"] = "Transportar 4",
        ["carregar2"] = "Transportar 2",
        ["relationship_already_taken"] = "%s já está num relacionamento com %s. Desejas pedir em namoro mesmo assim?",
        ["relationship_request"] = "%s quer NAMORAR com você.",
        ["relationship_request_married"] = "%s quer se CASAR com você.",
        ["relationship_finish_confirmation"] = "Você tem certeza que deseja terminar seu relacionamento?",

        ["tickets.create_commercial_direct_ticket"] = "Iniciar Atendimento Comercial",
    },

    ["fr-fr"] = {
        ["relationships"] = "Relations",
        ["start_wall_street"] = "Démarrer WallStreet",
        
        -- Medical and Emergency Services
        ["revive"] = "Réanimer",
        ["apply_plastic_surgery"] = "Appliquer Chirurgie Plastique",
        ["lay_patient_down"] = "Allonger le Patient",
        ["apply_bandages"] = "Appliquer des Bandages",
        ["extract_blood"] = "Extraire du Sang",
        ["diagnosis"] = "Informations",
        ["treatment"] = "Traitement",
        ["diagnostic"] = "Diagnostic",
        ["surgical_procedures"] = "Procédures Chirurgicales",

        -- Weapon License Actions
        ["add_weapon_license"] = "Ajouter Licence d'Armes",
        ["remove_weapon_license"] = "Retirer Licence d'Armes",
        ["check_weapon_license"] = "Vérifier Licence d'Armes",
        

        ["bombeiros_menu"] = "Menu Pompiers",
        
        -- ATM and Financial Actions
        ["enter_apartment"] = "Entrer dans l'Appartement",
        ["rob_atm"] = "Voler le Distributeur",
        ["access_atm"] = "Accéder au Distributeur",

        -- Shops and Food-related Interactions
        ["buy"] = "Acheter",
        ["drink"] = "Boire",
        ["fill"] = "Remplir",
        ["assemble_combo"] = "Assembler le Menu",
        ["assemble_sandwich"] = "Assembler le Sandwich",
        ["fill_cup"] = "Remplir le Verre",
        ["clean_vehicle"] = "Nettoyer le Véhicule",
        ["clean_vehicle_2"] = "Nettoyer le Véhicule 2",

        -- Call Delivery
        ["call_deliverers"] = "Appeler les Livreurs",
        ["call_burgershot"] = "Appeler Burger Shot",
        ["call_uwu_coffee"] = "Appeler UwU Coffee",
        ["call_pizza_this"] = "Appeler Pizza This",
        ["call_bean_machine"] = "Appeler Bean Machine",

        -- Interaction with Items/Objects
        ["call_phone"] = "Appeler",
        ["hide"] = "Cacher",
        ["inspect"] = "Inspecter",
        ["open"] = "Ouvrir",
        ["pick_up"] = "Ramasser",
        ["destroy"] = "Détruire",
        ["open_trunk"] = "Ouvrir le Coffre",
        ["close_trunk"] = "Fermer le Coffre",
        ["check_trunk"] = "Vérifier le Coffre",
        ["check_item"] = "Vérifier l'Objet",




        -- Vehicle Interactions
        ["remove_tire"] = "Retirer le Pneu",
        ["inspect_vehicle"] = "Inspecter le Véhicule",
        ["fix_vehicle"] = "Immobiliser le Véhicule",
        ["enter_trunk"] = "Entrer dans le Coffre",
        ["break_into_trunk"] = "Forcer le Coffre",
        ["impound_vehicle"] = "Saisir le Véhicule",
        ["report_vehicle"] = "Signaler le Véhicule",
        ["repair_vehicle"] = "Réparer le Véhicule",
        ["create_duplicate_key"] = "Créer une Clé Copie",
        ["change_plate"] = "Changer la Plaque",
        ["refuel"] = "Faire le Plein",
        ["roll_vehicle"] = "Retourner le Véhicule",
        ["tow_vehicle"] = "Remorquer le Véhicule",
        ["steal_trunk"] = "Voler le Coffre",
        ["remove_tyres"] = "Retirer les Pneus",
        ["put_in_vehicle_label"] = "Mettre dans le Véhicule",

        -- Miscellaneous Actions
        ["steal_shoes"] = "Voler les Chaussures",
        ["war_mode"] = "Mode Guerre",
        ["check_plate"] = "Vérifier la Plaque",
        ["register_vehicle"] = "Saisir le Véhicule",
        ["impound"] = "Saisir",
        ["family"] = "Famille",
        ["evaluate_player"] = "Évaluer le Joueur",
        ["fortune_wheel"] = "Roue de la Fortune",
        ["seize_items"] = "Saisir les Objets",

        -- Social Media Links
        ["instagram"] = "Instagram",
        ["tiktok"] = "TikTok",

        -- Yoga and Recreational Activities
        ["yoga"] = "Yoga",
        ["make_products"] = "Fabriquer des Produits",
        ["slot_machine"] = "Machine à Sous",

        -- Player and NPC Interactions
        ["talk"] = "Parler",
        ["frisk"] = "Fouiller",
        ["recruit_interaction"] = "Recruter",
        ["put_in_vehicle"] = "Mettre dans le Véhicule",
        ["loot"] = "Piller",
        ["report_box"] = "Rapport",
        ["steal_vehicle"] = "Voler le Véhicule",
        ["rate_player"] = "Évaluer le Joueur",

        -- WallStreet and Economy-related
        ["bank_operations"] = "Opérations Bancaires",

        -- Fuel and Vehicle Maintenance
        ["fuel_vehicle"] = "Faire le Plein",
        ["check_oil"] = "Vérifier l'Huile",

        -- Relationship Status
        ["relationship"] = "Relation",
        ["Solteiro"] = "Célibataire",
        ["married"] = "Marié",
        ["Namorando"] = "En Couple",
        ["engaged"] = "Fiancé",

        -- Custom User Interactions
        ["family_status"] = "Statut Famille",
        ["member"] = "Membre",
        ["leader"] = "Leader",

        -- Pets
        ["getup"] = "Lever",
        ["sit"] = "S'asseoir",
        ["sleep"] = "Dormir",
        ["enterCar"] = "Entrer dans la voiture",
        ["follow"] = "Suivre",
        ["guard"] = "Garder",
        ["exitCar"] = "Retirer l'Animal",
        ["changeName"] = "Changer le Nom",
        ["open_radial_menu"] = "Ouvrir le Menu Radial",
        ["officer_menu"] = "Menu Policier",
        ["interact_player"] = "Interactions",
        ["matchcity_view_profile"] = "Voir le profil",
        ["matchcity_add_contact"] = "Ajouter un contact",
        ["like"] = "Donner un Like",
        ["negociar"] = "Négocier",
        ["evaluate_player"] = "Évaluer le Joueur",
        ["open_perfil"] = "Ouvrir le Profil",
        ["paramedic_menu"] = "Menu Paramedic",
        ["open_animations"] = "Ouvrir Animations",
        ["open_sentimentals"] = "Ouvrir Sentimentaux",
        ["open_carry"] = "Ouvrir Porter",
        ["open_dance"] = "Ouvrir Danser",
        ["open_couple"] = "Ouvrir Couple",
        ["kiss"] = "Embrasser",
        ["abraco"] = "Calin",
        ["abracocintura"] = "Calin à la Taille",
        ["cavalinho"] = "Piggyback",
        ["dancinha1"] = "Danse 1",
        ["dancinha2"] = "Danse 2",
        ["dancinha3"] = "Danse 3",
        ["dancinha4"] = "Danse 4",
        ["ombro"] = "Épaule",
        ["carregar"] = "Porter",
        ["carregar4"] = "Porter 4",
        ["carregar2"] = "Porter 2",
        ["relationship_already_taken"] = "%s est déjà en relation avec %s. Voulez-vous quand même demander en couple?",
        ["relationship_request"] = "%s veut SORTIR AVEC vous.",
        ["relationship_request_married"] = "%s veut se MARIER avec vous.",
        ["relationship_finish_confirmation"] = "Êtes-vous sûr de vouloir terminer votre relation?",

        ["tickets.create_commercial_direct_ticket"] = "Démarrer le Service Commercial",
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
        ["fill_cup"] = "تعبئة الكوب",
        ["clean_vehicle"] = "تنظيف المركبة",
        ["clean_vehicle_2"] = "تنظيف المركبة 2",

        -- Call Delivery
        ["call_deliverers"] = "استدعاء المندوبين",
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
        ["apply_plastic_surgery"] = "تطبيق الجراحة التجميلية",
        ["revive"] = "إنعاش",
        ["lay_patient_down"] = "إ laying المريض",
        ["apply_bandages"] = "تطبيق الضمادات",
        ["extract_blood"] = "سحب الدم",
        ["diagnosis"] = "التشخيص",
        ["treatment"] = "العلاج",
        ["diagnostic"] = "التشخيص",
        ["surgical_procedures"] = "الإجراءات الجراحية",

        -- Weapon License Actions
        ["add_weapon_license"] = "إضافة ترخيص سلاح",
        ["remove_weapon_license"] = "إزالة ترخيص سلاح",
        ["check_weapon_license"] = "التحقق من ترخيص السلاح",

        -- Vehicle Interactions
        ["remove_tire"] = "إزالة الإطار",
        ["inspect_vehicle"] = "فحص المركبة",
        ["fix_vehicle"] = "إصلاح المركبة",
        ["enter_trunk"] = "الدخول إلى الصندوق",
        ["break_into_trunk"] = "اقتحام الصندوق",
        ["impound_vehicle"] = "حجز المركبة",
        ["report_vehicle"] = "الإبلاغ عن المركبة",
        ["repair_vehicle"] = "إصلاح المركبة",
        ["create_duplicate_key"] = "إنشاء مفتاح مكرر",
        ["change_plate"] = "تغيير اللوحة",
        ["refuel"] = "تزويد بالوقود",
        ["roll_vehicle"] = "قلب المركبة",
        ["tow_vehicle"] = "سحب المركبة",
        ["register_vehicle"] = "حجز المركبة",
        ["put_in_vehicle_label"] = "وضع في المركبة",

        -- Miscellaneous Actions
        ["steal_shoes"] = "سرقة الأحذية",
        ["war_mode"] = "وضع الحرب",
        ["check_plate"] = "التحقق من اللوحة",
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
        ["slot_machine"] = "آلة الحظ",

        -- Player and NPC Interactions
        ["talk"] = "تحدث",
        ["frisk"] = "تفتيش",
        ["recruit_interaction"] = "تجنيد",
        ["put_in_vehicle"] = "وضع في المركبة",
        ["loot"] = "نهب",
        ["report_box"] = "صندوق التقرير",
        ["steal_vehicle"] = "سرقة المركبة",
        ["rate_player"] = "تقييم اللاعب",

        -- WallStreet and Economy-related
        ["start_wall_street"] = "بدء وول ستريت",
        ["bank_operations"] = "العمليات البنكية",

        -- Fuel and Vehicle Maintenance
        ["fuel_vehicle"] = "تزويد المركبة بالوقود",
        ["check_oil"] = "التحقق من الزيت",

        -- Relationship Status
        ["relationship"] = "العلاقة",
        ["Solteiro"] = "أعزب",
        ["married"] = "متزوج",
        ["Namorando"] = "في علاقة",
        ["engaged"] = "مخطوب",
        ["relationships"] = "العلاقة",

        -- Custom User Interactions
        ["family_status"] = "حالة العائلة",
        ["member"] = "عضو",
        ["leader"] = "قائد",

        ["getup"] = "النهوض",
        ["sit"] = "الجلوس",
        ["sleep"] = "النوم",
        ["enterCar"] = "الدخول إلى السيارة",
        ["follow"] = "المتابعة",
        ["guard"] = "الحراسة",
        ["exitCar"] = "إخراج الحيوان من السيارة",
        ["changeName"] = "تغيير الاسم",
        ["open_radial_menu"] = "فتح القائمة الشعاعية",
        ["officer_menu"] = "قائمة الضابط",
        ["interact_player"] = "التفاعلات",
        ["matchcity_view_profile"] = "عرض الملف الشخصي",
        ["matchcity_add_contact"] = "إضافة جهة اتصال",
        ["like"] = "إعجاب",
        ["negociar"] = "تفاوض",
        ["evaluate_player"] = "تقييم اللاعب",
        ["open_perfil"] = "فتح الملف الشخصي",
        ["paramedic_menu"] = "قائمة المسعف",
        ["bombeiros_menu"] = "قائمة رجال الإطفاء",
        ["open_animations"] = "فتح الحركات",
        ["open_sentimentals"] = "فتح المشاعر",
        ["open_carry"] = "فتح الحمل",
        ["open_dance"] = "فتح الرقص",
        ["open_couple"] = "فتح الثنائي",
        ["kiss"] = "قبلة",
        ["relationship_already_taken"] = "%s في علاقة بالفعل مع %s. هل تريد طلب مواعدتهم على أي حال؟",
        ["relationship_request"] = "%s يريد مواعدتك.",
        ["relationship_request_married"] = "%s يريد الزواج منك.",
        ["relationship_finish_confirmation"] = "هل أنت متأكد أنك تريد إنهاء علاقتك؟",
        ["abraco"] = "عناق",
        ["abracocintura"] = "عناق على الخصر",
        ["cavalinho"] = "عناق على الكتف",
        ["dancinha1"] = "رقصة 1",
        ["dancinha2"] = "رقصة 2",
        ["ombro"] = "كتف",
        ["carregar"] = "حمل",
        ["carregar4"] = "حمل 4",
        ["carregar2"] = "حمل 2",
        ["massagemcosta"] = "تدليك الظهر",
        ["massagemperna"] = "تدليك المعدة",
        ["maosdadas2"] = "مصافحة 2",
        ["maosdadas3"] = "مصافحة 3",
        ["dancinha3"] = "رقصة 3",
        ["dancinha4"] = "رقصة 4",

        ["tickets.create_commercial_direct_ticket"] = "بدء التذكرة التجارية",
    }

}


---@param stringIndex string
---@return string
function _t( stringIndex )
    local baseLocale = translations[lang]

    if not baseLocale then 
        return stringIndex
    end

    return baseLocale[stringIndex] or stringIndex
end
