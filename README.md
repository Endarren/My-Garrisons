MyGarrisons will allow you to keep track of all the garrisons for every character you have. It has panel displaying all your characters that have a garrison. Each can be expanded to show the missions they have pending or done, as well as their construction and work orders.

## Features

### Commands

In-line commands are done with the slash command of "/gar".

**/gar timers**: Shows the timer frame.

**/gar portal**: This command opens the portal setter for this character (See Mage Tower/Spirit Lodge Timer below).

**/gar resetpos**: Resets the position of the timer frame to the center of the screen.

**/gar delete**: Delete a character from the addon. Type it in like this: "/gar delete Billy Mok'Nathal".

**/gar alpha**: Set the alpha value of the timer frame for this character. Type it in like this: "/gar alpha 0.5".

**/gar portal**: Shows the portal setter for this character's Mage Tower or Spirit Lodge.

**/gar trade**: Enables/Disables leaving Trade chat in your garrison. It will rejoin, if you were in it, when you are outside your garrison.

**/gar general**: Enables/Disables leaving General chat in your garrison. It will rejoin, if you were in it, when you are outside your garrison.

**/gar combat**: Sets whether or not the timers are hidden when you enter into combat. (They return once you leave combat if they were up before).

**/gar invasion**: Sets whether an exclamation mark is shown on a character that has a garrison invasion.

**/gar misscount**: Sets whether the number of pending and total number of missions a character has is shown.

**/gar shipcount**: Sets whether the number of pending and total number of shipments a character has is shown.

**/gar cache**: Sets whether the amount of resources in the garrison cache a character has is shown.

### Timers

Displays a list of the pending construction, follower missions, and work orders for all your characters, allowing you to know when construction or a mission on another character has ended.

![Garrison Timers](http://www.curseforge.com/media/images/80/284/My_Garrisons_Timer_Frame_Version_2.png "Garrison Timers")

Only characters who have completed the quest [Establish Your Garrison](http://www.wowhead.com/quest=34586) will be shown. Each character will also have a display a counter for the cache of the character. You will have to loot the cache once with the addon on for it to be accurate.

The timer frame can be moved by dragging with left or right clicking. You can also collapse the frame by pressing the minimize button or close it with the close button. To bring the timer frame back up, type "/gar timers".

There are two types of timers: Mission and Building timers. They are separated into two tabs, which can be expanded and collapsed independent of each other.

#### Mission Timers

![](http://www.curseforge.com/media/images/80/286/My_Garrisons_Timer_Frame_Missions_1_Version_2.png)![](http://www.curseforge.com/media/images/80/287/My_Garrisons_Timer_Frame_Missions_2_Version_2.png)

Currently, the mission timer displays the time left for the mission and the mission. By default, the mission timers are sorted from least time left to most time left. Also, a check mark will be added to the end of a mission that is complete, to make it more noticeable.

Mission timers also have a tooltip based on the one used in the game, and has an icon that the mission types used.

#### Building Timers

Building timers are used to display information about a building in a character's garrison. Unlike the mission timers, not all of the building timers look alike. The only universal aspect is the name and level of the building, which is placed at the top of the timer.

###### Construction Timers

![](http://www.curseforge.com/media/images/81/205/MG_Construction.png)

This shows the time left for a building to be finished. While being built, other building information is hidden, because the building cannot be accessed while being upgraded.

###### Shipment Timers

Buildings that have shipments or work orders will have a display showing their current status on the timer.

###### Stable Timer

![Stables Timer](http://www.curseforge.com/media/images/80/380/MG_Stable_Image.png "Stables Timer")

You can see that it has six icons on it. These are the six mounts that are earned through the stables mount training quest lines. The number next to each icon is how many out of all the quests that character has completed. Each icon also has a tooltip giving the name of that mount.

###### Barracks Timer

![](http://www.curseforge.com/media/images/80/381/MG_Barracks_Image.png)

The timer for the barracks shows the recovery time for your bodyguard followers. It will only show the bodyguards if the barracks is level 2 or above. The time til recovery is in minutes. **_A tooltip might be added later to help you identify who the timer is for._**

###### Gnomish Gearworks / Goblin Workshop Timer

**_Under work_**

The timer for this building will track the inventions that have been picked up and the daily siege engine/demolisher.

###### Lunarfall Inn / Frostwall Tavern Timer

**_Under work_**

The timer for the inn/ tavern will track your weekly follower recruitment and the quests offered by the guests.

###### Lunarfall Excavation / Frostwall Mines Timer

![](http://www.curseforge.com/media/images/80/382/MG_Mine_Timer.png)

The mine timer has the mine work orders/shipments. It also has how many of the ore nodes the character has in the mine, and how many they have dug up today.

###### Herb Farm

![](http://www.curseforge.com/media/images/81/157/MG_Herb_Garden.png)

The herb farm timer functions the same way the mine timer does. The only addition is the next crop, which will be detected when you talk to the npc at your farm who plants the herbs.

###### Mage Tower / Spirit Lodge Timer

![](http://www.curseforge.com/media/images/81/158/MG_Mage_Tower.png)

This feature will track which waygates the character has opened. The waygates can be detected automatically upon opening and closing. For waygates that have been set up, an option has been added to manually set which gate is open and to where. The icons used to for the waygates are from the exploration achievements for each zone that has a waygate. Moving the mouse over one of the icons will give the name of the place the waygate is located.

A standard work order timer is also added for 6.1, when the Mage Tower/Spirit Lodge will have work orders.

###### Menagerie Timer

![](http://www.curseforge.com/media/images/80/383/MG_Menagerie_timer.png)

The timer for the menagerie will show whether the character has completed the pet battle daily today.

###### Fishing Shack Timer

![](http://www.curseforge.com/media/images/81/159/MG_Fishing_Timer.png)

This timer will keep track of whether you have completed a fish daily today.

### Interface Customizations

![](http://www.curseforge.com/media/images/81/781/MG_Option_Frame_General.png)

#### Alpha

The alpha value of the timer frame can be set through command line. Each character has their own alpha value for their timer frame.

#### Character Header Info

These options will set what will be shown on each character in the timer list.

**Cache**: Sets whether the cache is shown or not.

**Invasions:** Sets whether it shows if a character has an available invasion.

**Completed Missions:** Sets whether the number of completed missions the character has are shown.

### Garrison Log

**_Under work_**

### Follower Page

**_Under work_**

### Alerts

**_Under work_**

### Sorting

**_Under work_**

Currently, your characters are sorted by name, then by realm name.

Missions are sorted by time remaining by default. Currently, there are no plans to sort missions by any other way.

Buildings will be sortable by name, work order time left (total or the current order), number of pending work orders.
